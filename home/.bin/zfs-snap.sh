#!/bin/sh
set -eu

usage() {
	cat <<'EOF'
Usage:
  zfs-snap.sh snap <dataset> [tag]
  zfs-snap.sh restore <dataset@snapshot> [--force]
  zfs-snap.sh prune <dataset> <keep_count> [prefix]
  zfs-snap.sh list [dataset]

Commands:
  snap     Create a timestamped snapshot on <dataset> (optional [tag] suffix)
  restore  Roll back <dataset@snapshot> (use --force to pass -r to zfs rollback)
  prune    Delete oldest snapshots on <dataset> beyond <keep_count> (optional [prefix])
  list     List snapshots for <dataset> or across all datasets
EOF
	exit 1
}

[ "$#" -ge 1 ] || usage
cmd="$1"
shift

case "$cmd" in
snap)
	[ "$#" -ge 1 ] && [ "$#" -le 2 ] || usage
	dataset="$1"
	tag="${2:-}"
	stamp="$(date '+%Y%m%d-%H%M%S')"
	if [ -n "$tag" ]; then
		snap_name="${dataset}@${stamp}-${tag}"
	else
		snap_name="${dataset}@${stamp}"
	fi
	zfs snapshot "$snap_name"
	printf 'Created: %s\n' "$snap_name"
	;;

restore)
	[ "$#" -ge 1 ] && [ "$#" -le 2 ] || usage
	target="$1"
	force="${2:-}"
	case "$target" in
	*@*) ;;
	*)
		printf 'Error: restore target must be <dataset@snapshot>\n' >&2
		exit 1
		;;
	esac
	if [ "$force" = "--force" ]; then
		zfs rollback -r "$target"
	elif [ -z "$force" ]; then
		zfs rollback "$target"
	else
		usage
	fi
	printf 'Restored: %s\n' "$target"
	;;

prune)
	[ "$#" -ge 2 ] && [ "$#" -le 3 ] || usage
	dataset="$1"
	keep="$2"
	prefix="${3:-}"

	case "$keep" in
	'' | *[!0-9]*)
		printf 'Error: keep_count must be a non-negative integer\n' >&2
		exit 1
		;;
	esac

	snaps="$(zfs list -H -o name -s creation -t snapshot "$dataset")"
	if [ -z "$snaps" ]; then
		printf 'No snapshots found for %s\n' "$dataset"
		exit 0
	fi

	filtered=""
	while IFS= read -r s; do
		short="${s#*@}"
		if [ -z "$prefix" ]; then
			filtered="${filtered}${s}"$'\n'
		else
			case "$short" in
			"${prefix}"*)
				filtered="${filtered}${s}"$'\n'
				;;
			esac
		fi
	done <<EOF
$snaps
EOF

	filtered="$(printf '%s' "$filtered" | sed '/^$/d')"
	[ -n "$filtered" ] || {
		printf 'No matching snapshots to prune on %s\n' "$dataset"
		exit 0
	}

	total="$(printf '%s' "$filtered" | wc -l | tr -d ' ')"
	if [ "$total" -le "$keep" ]; then
		printf 'Keeping all %s snapshots on %s (limit: %s)\n' "$total" "$dataset" "$keep"
		exit 0
	fi

	remove_count="$((total - keep))"
	printf '%s' "$filtered" | head -n "$remove_count" | while IFS= read -r old_snap; do
		zfs destroy "$old_snap"
		printf 'Pruned: %s\n' "$old_snap"
	done
	;;

list)
	[ "$#" -le 1 ] || usage
	if [ "$#" -eq 1 ]; then
		zfs list -t snapshot -o name,used,avail,refer,creation -s creation "$1"
	else
		zfs list -t snapshot -o name,used,avail,refer,creation -s creation
	fi
	;;

*)
	usage
	;;
esac

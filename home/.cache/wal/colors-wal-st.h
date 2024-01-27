const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#101215", /* black   */
  [1] = "#4A5562", /* red     */
  [2] = "#596572", /* green   */
  [3] = "#3A5D8B", /* yellow  */
  [4] = "#4F6D98", /* blue    */
  [5] = "#7589A5", /* magenta */
  [6] = "#8C9DB5", /* cyan    */
  [7] = "#c6cedd", /* white   */

  /* 8 bright colors */
  [8]  = "#8a909a",  /* black   */
  [9]  = "#4A5562",  /* red     */
  [10] = "#596572", /* green   */
  [11] = "#3A5D8B", /* yellow  */
  [12] = "#4F6D98", /* blue    */
  [13] = "#7589A5", /* magenta */
  [14] = "#8C9DB5", /* cyan    */
  [15] = "#c6cedd", /* white   */

  /* special colors */
  [256] = "#101215", /* background */
  [257] = "#c6cedd", /* foreground */
  [258] = "#c6cedd",     /* cursor */
};

/* Default colors (colorname index)
 * foreground, background, cursor */
 unsigned int defaultbg = 0;
 unsigned int defaultfg = 257;
 unsigned int defaultcs = 258;
 unsigned int defaultrcs= 258;

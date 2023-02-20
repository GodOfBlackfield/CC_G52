#def DEBUG 10
let x = 5;
#undef DEBUG
#ifdef DEBUG
dbg x;
#endif
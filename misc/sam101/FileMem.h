
/* Allokerar "minne" i filen */
ULONG FAllocMem(BPTR, ULONG);

/* Deallokerar "minne" i filen */
void FFreeMem(BPTR, ULONG, ULONG);

/* Kopierar en del av filen */
void FCopyMem(BPTR, ULONG, ULONG, ULONG, APTR, ULONG);

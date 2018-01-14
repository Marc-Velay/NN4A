/* audio definitions for use by calling program */
#define NChannelsIn		1	/* mono */
#define NChannelsOut		2	/* stereo */
#define SRateIn			44100L	/* sampling rate */
#define SRateOut		44100L
#define BytesPerSampleIn	2
#define BytesPerSampleOut	2

/* definition of complex number */
struct cpxFloat {
    float re;
    float im;
};

struct cpxDouble {
    double re;
    double im;
};

typedef struct _POINT {
    long int x;
    long int y;
} POINT;

typedef struct _RECT {
    int left;
    int top;
    int right;
    int bottom;
} RECT;

/* filterTap definition */
typedef struct {
    int delay;
    float weight;
} filterTap;

/* viewable structure to hold composite tap weights for synthesis */
#define compositeTaps 50
struct compositeFilter {
    int totalTaps;
    filterTap tap[compositeTaps];
};

/* prototypes for use by calling program */
void C_FFT(struct cpxFloat *data, int powerOf2, int ISI);
void spatialize(short *monoIn, short *stereoOut, int numSamples);
void soundscapeUpdate(POINT * sourcePt, POINT * headCenter,
		      RECT * roomModel, int inBufSize);
void soundscapeInit(int inBufSize);
void soundscapeFree();

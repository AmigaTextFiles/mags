// Osa 4. Tekijä: Juha-Pekka Jokela <jpjokela@surfeu.fi>
//Ohjelmasta on yksinkertaisuuden säilyttämiseksi jätetty pois joitain virhetilanteiden tarkastuksia.
#include <SDL/SDL.h>
#include <SDL/SDL_image.h>
#include <GL/gl.h>

#define TEXTURES    1
#define WIDTH       640 //Ikkunan koko
#define HEIGHT      480
#define BLSIZE      64  //Määrittää tekstuurin korkeuden & leveyden ruudulle piirrettynä
SDL_Surface *screen;
unsigned int texture[TEXTURES];

void display (void)
{
    int x, y;
    glOrtho(0.0f, WIDTH, HEIGHT, 0.0f, -1.0f, 1.0f); //Tämän jälkeen X- ja Y-koordinaatit vastaavat ikkunan pikseleitä

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();

    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
    glBindTexture(GL_TEXTURE_2D, texture[0]);
    glColor3ub(0xFF, 0xFF, 0xFF);
    glBegin(GL_QUADS);
    for (y=0;y<8;y++)
    {
        for (x=0;x<10;x++)
        {
            glTexCoord2f(0.0f, 0.0f); //Tekstuurin piste, jota seuraava vertex vastaa
            glVertex2i((BLSIZE*x),     (BLSIZE*y));
            glTexCoord2f(0.0f, 1.0f);
            glVertex2i((BLSIZE*x),     (BLSIZE*(1+y)));
            glTexCoord2f(1.0f, 1.0f);
            glVertex2i((BLSIZE*(1+x)), (BLSIZE*(1+y)));
            glTexCoord2f(1.0f, 0.0f);
            glVertex2i((BLSIZE*(1+x)), (BLSIZE*y));
        }
    }
    glEnd();
    SDL_GL_SwapBuffers(); //Vaihtaa näyttöpuskuria
}
void LoadTextures(void)
{
    SDL_Surface *TextureImage[1];
    glGenTextures(1, &texture[0]);
    if ((TextureImage[0]=IMG_Load("texture.png"))) //Lataa tekstuurin levyltä
    {
        glBindTexture(GL_TEXTURE_2D, texture[0]); //Ottaa käyttöön argumenttina annetun tekstuurin
        glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
        gluBuild2DMipmaps(GL_TEXTURE_2D, TextureImage[0]->format->BytesPerPixel,
                          TextureImage[0]->w, TextureImage[0]->h,
                          TextureImage[0]->format->BytesPerPixel==4?GL_RGBA:GL_RGB,
                          GL_UNSIGNED_BYTE, TextureImage[0]->pixels);
        SDL_FreeSurface(TextureImage[0]); //Tekstuuri on ladattu näytönohjaimen muistiin, joten sen voi poistaa muistista.
        //Tekstuurit vapautetaan ohjelman suorituksen jälkeen automaattisesti
    }
}
int Init(int width, int height)
{
    int videoFlags;
    const SDL_VideoInfo *videoInfo;
    if (SDL_Init(SDL_INIT_VIDEO)!=0)
    {
        fprintf( stderr, "Video initialization failed: %s\n", SDL_GetError());
        return FALSE;
    }
    videoInfo = SDL_GetVideoInfo();
    if (!videoInfo)
    {
        fprintf(stderr, "Video query failed: %s\n", SDL_GetError());
        return FALSE;
    }

    videoFlags  = SDL_OPENGL;
    videoFlags |= SDL_GL_DOUBLEBUFFER;
    videoFlags |= SDL_HWPALETTE;
    videoFlags |= SDL_FULLSCREEN;
    videoFlags |= (videoInfo->hw_available)?SDL_HWSURFACE:SDL_SWSURFACE; //Määrittää ikkunan tyypin

    if (videoInfo->blit_hw)
	videoFlags |= SDL_HWACCEL;

    SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);

    screen = SDL_SetVideoMode  (width, height, 0,
    			        videoFlags);
    if (screen)
    {
        glShadeModel(GL_SMOOTH);
        glClearColor(0.0f, 0.0f, 0.0f, 0.5f);
        glClearDepth(1.0f);
        glEnable(GL_CULL_FACE);
        glDisable(GL_DEPTH_TEST); //Depth buffer pois käytöstä
        glEnable(GL_TEXTURE_2D);
        glEnable(GL_BLEND);
        glEnable(GL_NORMALIZE);
        glEnable(GL_COLOR_MATERIAL);
        glMatrixMode(GL_PROJECTION);
        LoadTextures();
    }
    else
    {
        return FALSE;
    }
    return TRUE;
}

int main(int argc, char** argv)
{
    if (Init(WIDTH, HEIGHT))
    {
        display();
        display(); //tinygl-bugi
        SDL_Delay(3600); //pieni viive, jonka jälkeen ohjelma lopetetaan
    }
    SDL_Quit();
    return 0;
}

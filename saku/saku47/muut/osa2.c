//osa 2. Tekij‰: Juha-Pekka Jokela <jpjokela@surfeu.fi>

#define DETAIL 12
#include <math.h>
#ifdef __MORPHOS__
#include <proto/tinygl.h>
#else
#include <GL/gl.h>
#endif
//Tarkemmat kuvaukset eri argumenteista erillisess‰ kuvassa
void tree (int detail, float r1, float h1, float r2, float h2)
{
    //Funktiossa piirret‰‰n kuusi argumenttina annettujen mittojen perusteella.
    float x, z;
    int i;
    x=0;  //x=r1*sin(0);
    z=r1; //z=r1*cos(0);
    glColor3f(1.0f, 0.3f, 0.1f); //Asetetaan piirtov‰riksi ruskea
    glBegin(GL_QUADS);
    for (i=1;i<=detail;i++)
    {
        glVertex3f(x,   h1, z);
        glVertex3f(x, 0.0f, z);
        x=(r1*sin(((float)i/(float)detail)*2*M_PI));
        z=(r1*cos(((float)i/(float)detail)*2*M_PI));
        glVertex3f(x, 0.0f, z);
        glVertex3f(x,   h1, z);
    }
    //glEnd() j‰tetty pois, koska seuraava vaihekin piirret‰‰n quadeilla
    x=0; //x=sin(0);
    z=1; //z=cos(0);
    glColor3f(0.2f, 1.0f, 0.2f); //Asetetaan piirtov‰riksi vihre‰

    for (i=1;i<=detail;i++)
    {
        glVertex3f(r2*x, h1, r2*z);
        glVertex3f(r1*x, h1, r1*z);
        x=sin(((float)i/(float)detail)*2*M_PI);
        z=cos(((float)i/(float)detail)*2*M_PI);
        glVertex3f(r1*x, h1, r1*z);
        glVertex3f(r2*x, h1, r2*z);
    }
    glEnd();

    x=0;  //x=r2*sin(0);
    z=r2; //z=r2*cos(0);
    glBegin(GL_TRIANGLES); //Piirret‰‰n puun yl‰osa kolmioilla
    for (i=1;i<=detail;i++)
    {
        glVertex3f(x,    h1, z);
        glVertex3f(0, h1+h2, 0);
        x=(r2*sin(((float)i/(float)detail)*2*M_PI));
        z=(r2*cos(((float)i/(float)detail)*2*M_PI));
        glVertex3f(x, h1, z);
    }
    glEnd();
}

void display (void)
{
    int i;
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT); // Tyhjent‰‰ n‰ytˆn, t‰ll‰ kertaa myˆs depth bufferin
    glLoadIdentity(); // Asetetaan nykyinen matriisi identiteettimatriisiksi
    glTranslatef(-20.0f, 0.0f, -36.0f); //Siirt‰‰ origoa argumenttina annettujen arvojen verran
    //Piirret‰‰n 5 eri kokoista kuusta
    for (i=1;i<6;i++)
    {
        glPushMatrix(); //Kopioidaan nykyinen matriisi pinoon
        glTranslatef(-10.0f+10.0f*i, -4.0f, 0.0f);
        tree (DETAIL, (float)i/5.0f, 1+i, (float)i, 4.0f*(float)i);
        glPopMatrix(); //Palautetaan matriisi pinosta
    }
    glutSwapBuffers(); // Vaihtaa n‰kyvill‰ olevaa n‰yttˆ‰ (tuplapuskurointi)
}

void reshape (int w, int h)
{
    glViewport(0, 0, w, h);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    if (h==0)
    {
        h=1;
    }
    gluPerspective (80, (float)w/(float)h, 1.0, 5000.0);
    glMatrixMode (GL_MODELVIEW);
}

void Init(void)
{
    float light_pos[] = {40.0, 40.0, -80.0, 1.0};
    glShadeModel(GL_FLAT);
    glEnable (GL_COLOR_MATERIAL);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    glLightfv(GL_LIGHT0, GL_POSITION, light_pos);
}

int main(int argc, char** argv)
{
    glutInit            (&argc, argv);
    glutInitDisplayMode (GLUT_RGB|GLUT_DOUBLE|GLUT_DEPTH); // M‰‰ritt‰‰ ikkunan tyypin (RGB, tuplapuskurointi ja depth buffer)
    glutInitWindowSize  (640, 480); // M‰‰ritt‰‰ ikkunan resoluution.
    Init();
    glutFullScreen      ();
    glutCreateWindow    ("Osa 2"); // Ikkunan nimi.
    glutDisplayFunc     (display);
    glutReshapeFunc     (reshape);
    glutMainLoop        ();
    return 0;
}

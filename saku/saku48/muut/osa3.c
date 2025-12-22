//osa 3. Tekijä: Juha-Pekka Jokela <jpjokela@surfeu.fi>

#define DETAIL 8
#include <math.h>
#ifdef __MORPHOS__
#include <proto/tinygl.h>
#else
#include <GL/gl.h>
#endif

GLuint kuusi;
float rot=0.0f;

void tree (int detail, float r1, float h1, float r2, float h2)
{
    float x, z;
    int i;
    x=0;  //x=r1*sin(0);
    z=r1; //z=r1*cos(0);
    glColor3f(1.0f, 0.3f, 0.1f);
    glBegin(GL_QUADS);
    for (i=1;i<=detail;i++)
    {
        //Määrittelee vertexin (tai tason) normaalin
        glNormal3f((x/r1), 0.0f, (z/r1));
        glVertex3f(x,   h1, z);
        glNormal3f((x/r1), 0.0f, (z/r1));
        glVertex3f(x, 0.0f, z);
        x=(r1*sin(((float)i/(float)detail)*2*M_PI));
        z=(r1*cos(((float)i/(float)detail)*2*M_PI));
        glNormal3f((x/r1), 0.0f, (z/r1));
        glVertex3f(x, 0.0f, z);
        glNormal3f((x/r1), 0.0f, (z/r1));
        glVertex3f(x,   h1, z);
    }
    x=0; //x=sin(0);
    z=1; //z=cos(0);
    glColor3f(0.2f, 1.0f, 0.2f);

    for (i=1;i<=detail;i++)
    {
        glNormal3f(0.0f, -1.0f, 0.0f);
        glVertex3f(r2*x, h1, r2*z);
        glNormal3f(0.0f, -1.0f, 0.0f);
        glVertex3f(r1*x, h1, r1*z);
        x=sin(((float)i/(float)detail)*2*M_PI);
        z=cos(((float)i/(float)detail)*2*M_PI);
        glNormal3f(0.0f, -1.0f, 0.0f);
        glVertex3f(r1*x, h1, r1*z);
        glNormal3f(0.0f, -1.0f, 0.0f);
        glVertex3f(r2*x, h1, r2*z);
    }
    glEnd();

    x=0;  //x=r2*sin(0);
    z=r2; //z=r2*cos(0);
    glBegin(GL_TRIANGLES);
    for (i=1;i<=detail;i++)
    {
        glNormal3f(0.0f, 1.0f, 0.0f);
        glVertex3f(0, h1+h2, 0);
        glNormal3f((x/r2), 0.0f, (z/r2));
        glVertex3f(x,    h1, z);
        x=(r2*sin(((float)i/(float)detail)*2*M_PI));
        z=(r2*cos(((float)i/(float)detail)*2*M_PI));
        glNormal3f((x/r2), 0.0f, (z/r2));
        glVertex3f(x, h1, z);
    }
    glEnd();
}

void display (void)
{
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT); // Tyhjentää näytön, tällä kertaa myös depth bufferin
    glLoadIdentity();
    glTranslatef(0.0f, -4.0f, -8.0f);
    glRotatef(rot, 0.0f, 1.0f, 0.0f);//Pyöritys

    glCallList(kuusi); //Piirretään display listin 'kuusi' sisältö
    glutSwapBuffers();
    rot+=0.05f;
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
    GLfloat light_pos[]= {0.0, 0.0, 20.0, 1.0};
    GLfloat light_amb[]= {0.1f, 0.1f, 0.1f, 1.0f};
    GLfloat light_dif[]= {0.5f, 0.5f, 0.5f, 1.0f};

    glShadeModel(GL_SMOOTH); //Smooth shading
    glEnable (GL_COLOR_MATERIAL);
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE); //Piirretään polygoneista vain etupuoli
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    glLightfv(GL_LIGHT0, GL_POSITION, light_pos); //Valaistuksen parametrit
    glLightfv(GL_LIGHT0, GL_AMBIENT, light_amb);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, light_dif);

    kuusi=glGenLists(1); //Luodaan yksi uusi display list, indeksi kuusi-muuttujaan
    glNewList(kuusi, GL_COMPILE);
    tree(DETAIL, 0.5f, 4.0f, 2.0f, 6.0f); //"Piirretään" kuusi display listiin. Tässä vaiheessa ei piirretä mitään ruudulle.
    glEndList();
}

int main(int argc, char** argv)
{
    glutInit            (&argc, argv);
    glutInitDisplayMode (GLUT_RGB|GLUT_DOUBLE|GLUT_DEPTH);
    glutInitWindowSize  (640, 480);
    Init();
    glutFullScreen      ();
    glutCreateWindow    ("Osa 3");
    glutDisplayFunc     (display);
    glutReshapeFunc     (reshape);
    glutIdleFunc        (display);
    glutMainLoop        ();
    return 0;
}

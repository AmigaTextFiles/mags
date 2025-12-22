// Osa 1. Tekij‰: Juha-Pekka Jokela <jpjokela@surfeu.fi>
#ifdef __MORPHOS__
#include <proto/tinygl.h>
#else
#include <GL/gl.h>
#endif

void display (void)
{
    glClear(GL_COLOR_BUFFER_BIT); // Tyhjent‰‰ n‰ytˆn.
    glLoadIdentity(); // Asetetaan nykyinen matriisi identiteettimatriisiksi ("resetoidaan" matriisi)
    glTranslatef(0.0f, 0.0f, -2.0f); //Siirt‰‰ origoa argumenttina annettujen arvojen verran
    glRotatef(180.0f, 0.0f, 0.0f, 1.0f); //Pyˆritt‰‰ koordinaatistoa argumenttien mukaan
    glBegin(GL_TRIANGLES); // M‰‰ritt‰‰, mit‰ piirret‰‰n
    glColor3f(1.0f, 0.0f, 0.0f); // M‰‰ritt‰‰ v‰rin, mill‰ piirret‰‰n. V‰ri pit‰‰ antaa ennen koordinaatteja.
    glVertex3f(0.0f, 1.0f, 0.0f); // Antaa yhden pisteen koordinaatit. Tarvittavien pisteiden m‰‰r‰ riippuu siit‰, mit‰ piirret‰‰n.
    glColor3f(0.0f, 1.0f, 0.0f); // Vaihtaa piirtov‰ri‰ (muuten jatketaan edellisell‰ v‰rill‰)
    glVertex3f(-1.0f, -1.0f, 0.0f);
    glColor3f(0.0f, 0.0f, 1.0f);
    glVertex3f(1.0f, -1.0f, 0.0f);
    glEnd(); // Lopetetaan piirt‰minen
    glutSwapBuffers(); // Vaihtaa n‰kyvill‰ olevaa puskuria (tuplapuskurointi)
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

int main(int argc, char** argv)
{
    glutInit            (&argc, argv);
    glutInitDisplayMode (GLUT_RGB|GLUT_DOUBLE); // M‰‰ritt‰‰ ikkunan tyypin (RGB ja tuplapuskurointi)
    glutInitWindowSize  (640, 480); // M‰‰ritt‰‰ ikkunan resoluution.
    //Kommentoi seuraava rivi, jos haluat ikkunan oman screenin tilalta
    glutFullScreen      ();
    glutCreateWindow    ("Osa 1"); // Ikkunan nimi.
    glutDisplayFunc     (display);
    glutReshapeFunc     (reshape);
    glutMainLoop        ();
    return 0;
}

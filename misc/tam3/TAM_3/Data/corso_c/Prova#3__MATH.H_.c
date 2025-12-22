/*   Terzo programma in C: le funzioni e operatori matematici. Se non va in guru...  */
/*   ... no, non uso il coprocessore!!                                    */

/*   26/12/1994    */

#include <stdio.h>
#include <math.h>	/*   Si deve includere per le funzioni matematiche	*/
			/*   Fra le altre cose, definisce la variabile PI e le  */
			/*   sue frazioni: PI, PID2, ecc.			*/

float a;     		/*   Definisce la variabile float a in virgola mobile	*/

main()
{
	a = (5.324545 + (2.653854 * 3)) / 3;
	printf("\nEspressione con numeri in virgola mobile");
	printf("\n(5.324545 + (2.653854 * 3)) / 3 = %f\n", a);

        printf("\nLe principali funzioni trigonometriche:\n");
	printf("sin(PI/2) = %f\n", sin(PID2));
	printf("cos(PI)   = %f\n", cos(PI));
	printf("tan(PI/2) = %f\n", tan(PID4));
	printf("asin(1)   = %f\n", asin(1.0));
	printf("acos(0)   = %f\n", acos(0.0));
	printf("atan(1)   = %f\n", atan(1.0));

	printf("\nEspressione con funzioni trigonometriche:");
	a = acos(sin(PID2) * tan(PI)) * atan(1.0);
	printf("\nacos(sin(PI/2) * tan(PI)) * atan(1.0) = %f\n", a);

	printf("\nAlcune funzioni matematiche:\n");
	printf("abs(-10)  = %d\n", abs(-10));
	printf("fabs(-1.2) = %f\n", fabs(-1.2));
	printf("log(5)    = %f\n", log(5.0));
	printf("log10(5)  = %f\n", log10(5.0));
	printf("sqrt(400) = %f\n", sqrt(400.0));
	printf("ceil(4.5) = %f\n", ceil(4.5));
	printf("floor(4.5) = %f\n", floor(4.5));
	printf("exp(2)    = %e\n", exp(2.0));
	printf("pow(3,3)  = %f\n", pow(3.0,3.0));
	printf("pow2(4)   = %f\n", pow2(4.0));

        printf("\nEspressione con funzioni matematiche:");
	a = pow((log(3.0) * 4), sqrt(5.0)) * log10(8.0);
	printf("\npow((log(3.0) * 4), sqrt(5.0)) * log10(8.0) = %f\n", a);
}

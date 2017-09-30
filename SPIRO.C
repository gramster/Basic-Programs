#include <stdlib.h>
#include <time.h>
#include <stdio.h>
#include <math.h>
#include <graphics.h>
#include <conio.h>

#define LSTKSZ	512

#define MIDX		319
#define MIDY		199

#define FNRAD(x)	((x)*0.0174533)

int linestack[LSTKSZ][2];

int lastx, lasty;

void Draw(int x, int y, int color, int spots, int flash)
{
		static int oldi=0, i=0;
		if (spots)
			putpixel(x,y,color);
		else
		{
			setcolor(color);
			line (lastx, lasty, x, y);
		}
		if (flash)
		{
			oldi = i;
			i = (i+1)%LSTKSZ;
			if (linestack[oldi][0] || linestack[oldi][1])
				if (spots)
					putpixel(linestack[oldi][0], linestack[oldi][1], BLACK);
				else
				{
					setcolor(BLACK);
					line (linestack[i][0], linestack[i][1],
						linestack[oldi][0], linestack[oldi][1]);
				}
			linestack[oldi][0] = x;
			linestack[oldi][1] = y;
		}
		else if (i != oldi)
		{
			int tmpi = i;
			i = (i+1)%LSTKSZ;
			if (linestack[tmpi][0] || linestack[tmpi][1])
				if (spots)
					putpixel(linestack[tmpi][0], linestack[tmpi][1], BLACK);
				else
				{
					setcolor(BLACK);
					line (linestack[i][0], linestack[i][1],
						linestack[tmpi][0], linestack[tmpi][1]);
				}
		}
		lastx = x;
		lasty = y;
}

void DrawLine(int startx, int starty, int endx, int endy, int color,
	int flash, int spot)
{
	Draw(startx, starty, color, spot, flash);
	Draw(endx, endy, color, spot, flash);
}

void stars(int rx, int ry, int wx, int wy, int no, int an, int color,
	int flash, int spot)
{
	int m, n, startx, starty, endx, endy, t, xinc1, xinc2, yinc1, yinc2, i, a;
	m = startx = MIDX;
	n = MIDY + ry;
	starty = MIDY + ry/wy;
	xinc1 = 0;
	yinc1 = (n-starty)/no;
	t = 0;
	setcolor(color);
	for (i = 0; i <= (360/an); i++)
	{
		t += an;
		endx = MIDX + rx * sin(FNRAD(t));
		endy = MIDY + ry * cos(FNRAD(t));
		m = (endx - MIDX)/wx + MIDX;
		n = (endy - MIDY)/wy + MIDY;
		xinc2 = (m-endx)/no;
		yinc2 = (n-endy)/no;
		for (a = 0; a < no; a++)
			DrawLine(startx+xinc1*a, starty+yinc1*a, endx+xinc2*a, endy+yinc2*a,
				color,flash,spot);
		startx = m;
		starty = n;
		xinc1 = -xinc2;
		yinc1 = -yinc2;
	}
}

void spiro(int fixedR, int turnR, int dist, int inside, int color,
	int flash, int spots)
{
	float dt, theta1, theta2, dd;
	int D, x, y, iter=flash ? 360 : 14400;
	inside = inside ? -1 : 1;
	D=fixedR+inside*turnR;
	if ((D+turnR)>(2*MIDY))
		return; // wheels too big for screen
	dt=((float)fixedR)/((float)turnR)*(float)inside; /* + inside?? */
  lastx = x = MIDX; 
	lasty = y = MIDY+D+dist;
	theta1 = theta2 = 0.;
	dd = (float)D;
	do
	{
		float A1=FNRAD(theta1), A2=FNRAD(theta2);
		x = (int)(dd*sin(A1)+dist*sin(A2))+MIDX;
		y = (int)(dd*cos(A1)+dist*cos(A2))+MIDY;
		Draw(x,y,color,spots,flash);
		theta1=theta1+1.;
		theta2=theta2+dt;
		if (theta1 >= 360.) theta1 = 0.;
		while (theta2 < 0.) 
		{
			theta2 += 360.;
		}
		while (theta2 >= 360.) 
		{
			theta2 -= 360.;
		}
		iter--;
	}
	while (iter && (theta1>0.5 || theta2>0.5));
}

main()
{
	int gdriver = DETECT, gmode, f, m, d, i, j, fl = 0, inc, spot, typ=0,
		rx, ry, wx, wy, cnt;
	initgraph(&gdriver,&gmode,"");
	setcolor(WHITE);
	randomize();
	for (j = 0; j<LSTKSZ; j++)
	{
		linestack[j][0] = 0;
		linestack[j][1] = 0;
	}
	cnt = 2+random(5);
	do
	{
		if (fl-- > 0)
			setlinestyle(SOLID_LINE,0,2);
		else
		{
			setlinestyle(SOLID_LINE,0,1);
//			typ = (random(3)==0);
			typ = 0;
			fl = (typ ? (2+random(4)) : (10+random(30)));
			spot = random(2);
			if (cnt--<=0)
			{
				cnt = 2+random(5);
				cleardevice();
				for (j = 0; j<LSTKSZ; j++)
				{
					linestack[j][0] = 0;
					linestack[j][1] = 0;
				}
			}
			if (typ==0)
			{
				do
				{
					f = 10+random(150);
					m = 10+random(150);
					i = random(3); // favour inside
				}
				while ((i && m>=f) || (!i && (m+f)>180));
				d = 5 + random(m-6);
				inc = random(2) ? 1 : -1;
			}
			else
			{
				rx = 150+random(150);
				ry = 90+random(90);
				wx = random(rx);
				wy = random(ry);
				m = 10+random(30);
				d = 1 + random(90);
			}
		}
		if (typ==0)
		{
			spiro(f,m,d,i, 1+random(7), fl>1?fl:0, spot);
			if (fl>1) d += inc;
		}
		else
		{
			stars(rx, ry, wx, wy, m, d++, 1+random(7), fl, spot);
		}
	}
	while (!kbhit() || getch()!=27);
	closegraph();
	puts("Spiro v1.0 (c) 1994 by Graham Wheeler. Distribute freely.");
	puts("Thank you for using spiro!");
	return 0;
}


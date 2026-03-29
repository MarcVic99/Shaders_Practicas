#ifndef VORONOI_PERSONAL_INCLUDED
#define VORONOI_PERSONAL_INCLUDED

// Función Hash para aleatoriedad (requisito de IQ)
float2 voronoi_hash(float2 p)
{
    return frac(sin(float2(dot(p, float2(127.1, 311.7)), dot(p, float2(269.5, 183.3)))) * 43758.5453);
}

// IMPORTANTE: El nombre de la función termina en _float para Shader Graph
void VoronoiCustom_float(float2 UV, float Time, float Scale, out float Cells, out float Lines)
{
    float2 p = UV * Scale;
    float2 n = floor(p);
    float2 f = frac(p);

    float2 mg, mr;
    float md = 8.0;

    // PRIMER PASE: Células (patrón de burbujas/cáusticas)
    for (int j = -1; j <= 1; j++)
    {
        for (int i = -1; i <= 1; i++)
        {
            float2 g = float2(float(i), float(j));
            float2 o = voronoi_hash(n + g);
            
            // Animación de los puntos centrales
            o = 0.5 + 0.5 * sin(Time + 6.2831 * o);
            
            float2 r = g + o - f;
            float d = dot(r, r);

            if (d < md)
            {
                md = d;
                mr = r; // Vector a la celda más cercana
                mg = g;
            }
        }
    }

    // SEGUNDO PASE: Distancia a los bordes (Líneas de Voronoi matemáticas)
    md = 8.0;
    for (int jj = -2; jj <= 2; jj++)
    {
        for (int ii = -2; ii <= 2; ii++)
        {
            float2 g = mg + float2(float(ii), float(jj));
            float2 o = voronoi_hash(n + g);
            o = 0.5 + 0.5 * sin(Time + 6.2831 * o);
            
            float2 r = g + o - f;

            if (dot(mr - r, mr - r) > 0.00001)
            {
                // Cálculo específico para "Voronoi Lines" según IQ
                md = min(md, dot(0.5 * (mr + r), normalize(r - mr)));
            }
        }
    }

    // ASIGNACIÓN DE SALIDAS (Esto quita el error de 'uninitialized variable')
    Cells = sqrt(dot(mr, mr));
    Lines = md;
}

#endif
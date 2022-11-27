#include <stdio.h>

double calcFunc(double a, double b, double x);

double integrate(double a, double b, double L, double R);

int main(int argc, char* argv[]) {
    FILE* input = stdin;
    FILE* output = stdout;

    if (argc > 2) {
        input = fopen(argv[1], "r");
        output = fopen(argv[2], "w");
    }

    double a, b, L, R;
    fscanf(input, "%lf %lf %lf %lf", &a, &b, &L, &R);

    if (R < L) {
        fprintf(output, "left side must be lower then right");
        return 1;
    }
    if (L * R <= 0) {
        fprintf(output, "segment must not include 0");
        return 1;
    }

    fprintf(output, "%f\n", integrate(a, b, L, R));

    if (argc > 2) {
        fclose(input);
        fclose(output);
    }
    return 0;
}

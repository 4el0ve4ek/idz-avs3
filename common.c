
double calcFunc(double a, double b, double x){
    return a + b / (x * x * x * x);
}

double integrate(double a, double b, double L, double R) {
    const double precision = 0.0001;
    double res = 0;

    while (L < R) {
        double step = precision;
        if (R - L < step) {
            step = R - L;
        }
        res += step * calcFunc(a, b, L + step / 2);
        L += step;
    }
    return res;
}

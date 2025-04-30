public class Calculadora_202321250037 {
    
    /**
     * Realiza a operação de soma entre dois números
     * @param a primeiro termo
     * @param b segundo termo
     * @return resultado da soma
     */
    public double soma(double a, double b) {
        return a + b;
    }
    
    /**
     * Realiza a operação de subtração entre dois termos
     * @param a primeiro termo
     * @param b segundo termo
     * @return resultado da subtração
     */
    public double subtracao(double a, double b) {
        return a - b;
    }
    
    /**
     * Realiza a operação de multiplicação entre dois termos
     * @param a primeiro termo
     * @param b segundo termo
     * @return resultado da multiplicação
     */
    public double multiplicacao(double a, double b) {
        return a * b;
    }
    
    /**
     * Realiza a operação de divisão entre dois termos
     * @param a numerador
     * @param b denominador
     * @return resultado da divisão
     * @throws ArithmeticException se o denominador for zero
     */
    public double divisao(double a, double b) {
        if (b == 0) {
            throw new ArithmeticException("Divisão por zero não é permitida nessa calculadora.");
        }
        return a / b;
    }
}
public class Calculadora_202321250037 {
    private double a;
    private double b;
    
    /**
     * Construtor da calculadora que recebe os dois operandos
     * @param a primeiro número
     * @param b segundo número
     */
    public Calculadora_202321250037(double a, double b) {
        this.a = a;
        this.b = b;
    }
    
    /**
     * Obtém o valor do primeiro operando
     * @return o valor de a
     */
    public double getA() {
        return this.a;
    }
    
    /**
     * Obtém o valor do segundo operando
     * @return o valor de b
     */
    public double getB() {
        return this.b;
    }
    
    /**
     * Define um novo valor para o primeiro operando
     * @param a novo valor para a
     */
    public void setA(double a) {
        this.a = a;
    }
    
    /**
     * Define um novo valor para o segundo operando
     * @param b novo valor para b
     */
    public void setB(double b) {
        this.b = b;
    }
    
    /**
     * Realiza a operação de soma entre os dois atributos
     * @return resultado da soma
     */
    public double soma() {
        return this.a + this.b;
    }
    
    /**
     * Realiza a operação de subtração entre os dois atributos
     * @return resultado da subtração
     */
    public double subtracao() {
        return this.a - this.b;
    }
    
    /**
     * Realiza a operação de multiplicação entre os dois atributos
     * @return resultado da multiplicação
     */
    public double multiplicacao() {
        return this.a * this.b;
    }
    
    /**
     * Realiza a operação de divisão entre os dois atributos
     * @return resultado da divisão
     * @throws ArithmeticException se o denominador for zero
     */
    public double divisao() {
        if (this.b == 0) {
            throw new ArithmeticException("Divisão por zero não é permitida!");
        }
        return this.a / this.b;
    }
}
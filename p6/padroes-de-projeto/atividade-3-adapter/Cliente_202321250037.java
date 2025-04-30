public class Cliente_202321250037 {
    public static void main(String[] args) {
        Calculadora_202321250037 calculadora = new Calculadora_202321250037();
        
        double a = 10.0;
        double b = 5.0;
        
        System.out.println("===== CALCULADORA =====");
        System.out.println("Operandos: a = " + a + ", b = " + b);
        
        double resultadoSoma = calculadora.soma(a, b);
        System.out.println("Soma: " + a + " + " + b + " = " + resultadoSoma);
        
        double resultadoSubtracao = calculadora.subtracao(a, b);
        System.out.println("Subtração: " + a + " - " + b + " = " + resultadoSubtracao);
        
        double resultadoMultiplicacao = calculadora.multiplicacao(a, b);
        System.out.println("Multiplicação: " + a + " * " + b + " = " + resultadoMultiplicacao);
        
        try {
            double resultadoDivisao = calculadora.divisao(a, b);
            System.out.println("Divisão: " + a + " / " + b + " = " + resultadoDivisao);
        } catch (ArithmeticException e) {
            System.out.println("Erro: " + e.getMessage());
        }
        
        // Teste de erro - divisão por zero
        try {
            System.out.println("\nTentando divisão por zero:");
            double resultadoDivisaoPorZero = calculadora.divisao(a, 0);
            System.out.println("Divisão: " + a + " / 0 = " + resultadoDivisaoPorZero);
        } catch (ArithmeticException e) {
            System.out.println("Erro: " + e.getMessage());
        }
    }
}
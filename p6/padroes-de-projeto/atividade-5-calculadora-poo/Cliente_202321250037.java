public class Cliente_202321250037 {
    public static void main(String[] args) {
        double a = 10.0;
        double b = 5.0;
        
        Calculadora_202321250037 calculadora = new Calculadora_202321250037(a, b);
        
        System.out.println("===== CALCULADORA =====");
        System.out.println("Termos: a = " + calculadora.getA() + ", b = " + calculadora.getB());
        
        double resultadoSoma = calculadora.soma();
        System.out.println("Soma: " + calculadora.getA() + " + " + calculadora.getB() + " = " + resultadoSoma);
        
        double resultadoSubtracao = calculadora.subtracao();
        System.out.println("Subtracao: " + calculadora.getA() + " - " + calculadora.getB() + " = " + resultadoSubtracao);
        
        double resultadoMultiplicacao = calculadora.multiplicacao();
        System.out.println("Multiplicacao: " + calculadora.getA() + " * " + calculadora.getB() + " = " + resultadoMultiplicacao);
        
        try {
            double resultadoDivisao = calculadora.divisao();
            System.out.println("Divisao: " + calculadora.getA() + " / " + calculadora.getB() + " = " + resultadoDivisao);
        } catch (ArithmeticException e) {
            System.out.println("Erro: " + e.getMessage());
        }
        
        // Teste de erro - divisão por zero
        System.out.println("\nTentando divisao por zero:");
        calculadora.setB(0);
        try {
            double resultadoDivisaoPorZero = calculadora.divisao();
            System.out.println("Divisao: " + calculadora.getA() + " / " + calculadora.getB() + " = " + resultadoDivisaoPorZero);
        } catch (ArithmeticException e) {
            System.out.println("Erro: " + e.getMessage());
        }
        
        System.out.println("\nAlterando termos para a = 20.0 e b = 4.0");
        calculadora.setA(20.0);
        calculadora.setB(4.0);
        System.out.println("Novos operandos: a = " + calculadora.getA() + ", b = " + calculadora.getB());
        
        System.out.println("Nova soma: " + calculadora.soma());
        System.out.println("Nova subtracao: " + calculadora.subtracao());
        System.out.println("Nova multiplicacao: " + calculadora.multiplicacao());
        System.out.println("Nova divisao: " + calculadora.divisao());
    }
}
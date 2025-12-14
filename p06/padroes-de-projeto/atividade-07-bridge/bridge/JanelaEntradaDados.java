package bridge;

public class JanelaEntradaDados extends JanelaAbstrata { // Nova classe para entrada de dados
    public JanelaEntradaDados(JanelaImplementada j) {
        super(j);
    }
    
    @Override
    public void desenhar() {
        desenharJanela("Janela de Entrada de Dados");
        desenharEditBox("Digite seus dados");
        desenharBotao("Enviar");
        desenharBotao("Cancelar");
    }
}
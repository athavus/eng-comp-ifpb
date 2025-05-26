package bridge;

public abstract class JanelaAbstrata {
    protected JanelaImplementada janela;
    
    public JanelaAbstrata(JanelaImplementada j) {
        janela = j;
    }
    
    public void desenharJanela(String titulo) {
        janela.desenharJanela(titulo);
    }
    
    public void desenharBotao(String titulo) {
        janela.desenharBotao(titulo);
    }
    
    public void desenharEditBox(String titulo) { // Novo método adicionado
        janela.desenharEditBox(titulo);
    }
    
    public abstract void desenhar();
}
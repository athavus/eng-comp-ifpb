package bridge;

public class JanelaMac implements JanelaImplementada { // Nova classe para MacOS
    @Override
    public void desenharJanela(String titulo) {
        System.out.println(titulo + " - Janela Mac");
    }
    
    @Override
    public void desenharBotao(String titulo) {
        System.out.println(titulo + " - Botão Mac");
    }
    
    @Override
    public void desenharEditBox(String titulo) {
        System.out.println(titulo + " - EditBox Mac");
    }
}
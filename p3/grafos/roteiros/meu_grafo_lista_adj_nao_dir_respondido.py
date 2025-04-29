from bibgrafo.grafo_lista_adj_nao_dir import GrafoListaAdjacenciaNaoDirecionado
from bibgrafo.grafo_errors import *


class MeuGrafo(GrafoListaAdjacenciaNaoDirecionado):

    def vertices_nao_adjacentes(self):
        '''
        Provê um conjunto de vértices não adjacentes no grafo.
        O conjunto terá o seguinte formato: {X-Z, X-W, ...}
        Onde X, Z e W são vértices no grafo que não tem uma aresta entre eles.
        :return: Um objeto do tipo set que contém os pares de vértices não adjacentes
        '''


        pass # Apague essa instrução e inicie seu código aqui

    def ha_laco(self):
        '''
        Verifica se existe algum laço no grafo.
        :return: Um valor booleano que indica se existe algum laço.
        '''

        for aresta in self.arestas.values():
            if aresta.v1 == aresta.v2:
                return True
        return False


    def grau(self, V=''):
        '''
        Provê o grau do vértice passado como parâmetro
        :param V: O rótulo do vértice a ser analisado
        :return: Um valor inteiro que indica o grau do vértice
        :raises: VerticeInvalidoError se o vértice não existe no grafo
        '''

        grau = 0

        if not self.existe_rotulo_vertice(V):
            raise VerticeInvalidoError("")

        for aresta in self.arestas.values():
            if aresta.v1.rotulo == V:
                grau += 1
            if aresta.v2.rotulo == V:
                grau += 1

        return grau


    def ha_paralelas(self):
        '''
        Verifica se há arestas paralelas no grafo
        :return: Um valor booleano que indica se existem arestas paralelas no grafo.
        '''

        arestas_vistas = {}

        for aresta in self.arestas.values():
            v1, v2 = sorted([aresta.v1.rotulo, aresta.v2.rotulo])
            par = f"{v1}-{v2}"

            if par in arestas_vistas:
                return True

            arestas_vistas[par] = True

        return False


    def arestas_sobre_vertice(self, V):
        '''
        Provê uma lista que contém os rótulos das arestas que incidem sobre o vértice passado como parâmetro
        :param V: Um string com o rótulo do vértice a ser analisado
        :return: Uma lista os rótulos das arestas que incidem sobre o vértice
        :raises: VerticeInvalidoError se o vértice não existe no grafo
        '''

        if not self.existe_rotulo_vertice(V):
            raise VerticeInvalidoError("")

        incidencia_arestas = set()

        for aresta in self.arestas:
            if self.arestas[aresta].v1.rotulo == V or self.arestas[aresta].v2.rotulo == V:
                incidencia_arestas.add(aresta)

        return incidencia_arestas


    def eh_completo(self):
        '''
        Verifica se o grafo é completo.
        :return: Um valor booleano que indica se o grafo é completo
        '''


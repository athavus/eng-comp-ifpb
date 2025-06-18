from bibgrafo.grafo_matriz_adj_nao_dir import GrafoMatrizAdjacenciaNaoDirecionado
from bibgrafo.grafo_errors import *


class MeuGrafo(GrafoMatrizAdjacenciaNaoDirecionado):

    def vertices_nao_adjacentes(self):
        '''
        Provê um conjunto (set) de vértices não adjacentes no grafo.
        O conjunto terá o seguinte formato: {X-Z, X-W, ...}
        Onde X, Z e W são vértices no grafo que não tem uma aresta entre eles.
        :return: Um conjunto (set) com os pares de vértices não adjacentes
        '''

        vertices_nao_adjacentes = set()

        for linha in range(len(self.matriz)):
            for coluna in range(linha + 1, len(self.matriz)):
                if len(self.matriz[linha][coluna]) == 0:
                    rotulo1 = self.vertices[linha]
                    rotulo2 = self.vertices[coluna]
                    vertices_nao_adjacentes.add(f'{rotulo1}-{rotulo2}')

        return vertices_nao_adjacentes

    def ha_laco(self):
        '''
        Verifica se existe algum laço no grafo.
        :return: Um valor booleano que indica se existe algum laço.
        '''

        for celula in range(len(self.matriz)):
            if len(self.matriz[celula][celula]) > 0:
                return True
        return False


    def grau(self, V=''):
        '''
        Provê o grau do vértice passado como parâmetro
        :param V: O rótulo do vértice a ser analisado
        :return: Um valor inteiro que indica o grau do vértice
        :raises: VerticeInvalidoError se o vértice não existe no grafo
        '''

        if not self.existe_rotulo_vertice(V):
            raise VerticeInvalidoError("")

        grau = 0

        for linha in range(len(self.matriz)):
            if str(self.vertices[linha]) == V:
                for coluna in range(len(self.matriz)):
                    if len(self.matriz[linha][coluna]) > 0:
                        if linha == coluna:
                            grau += len(self.matriz[linha][coluna]) * 2
                        else:
                            grau += len(self.matriz[linha][coluna])

        return grau

    def ha_paralelas(self):
        '''
        Verifica se há arestas paralelas no grafo
        :return: Um valor booleano que indica se existem arestas paralelas no grafo.
        '''

        for linha in range(len(self.matriz)):
            for coluna in range(len(self.matriz)):
                if len(self.matriz[linha][coluna]) > 1:
                    return True
        return False

    def arestas_sobre_vertice(self, V):
        '''
        Provê um conjunto (set) que contém os rótulos das arestas que
        incidem sobre o vértice passado como parâmetro
        :param V: O vértice a ser analisado
        :return: Um conjunto com os rótulos das arestas que incidem sobre o vértice
        :raises: VerticeInvalidoError se o vértice não existe no grafo
        '''
        if not self.existe_rotulo_vertice(V):
            raise VerticeInvalidoError("")

        arestas_incidentes = set()

        for linha in range(len(self.matriz)):
            if str(self.vertices[linha]) == V:
                for coluna in range(len(self.matriz)):
                    if len(self.matriz[linha][coluna]) >= 1:
                        for rotulo in self.matriz[linha][coluna]:
                            arestas_incidentes.add(rotulo)

        arestas_incidentes = sorted(arestas_incidentes)

        return arestas_incidentes


    def eh_completo(self):
        '''
        Verifica se o grafo é completo.
        :return: Um valor booleano que indica se o grafo é completo
        '''

        if self.ha_paralelas() or self.ha_laco():
            return False

        for linha in range(len(self.matriz)):
            for coluna in range(len(self.matriz)):
                if linha != coluna:
                    if len(self.matriz[linha][coluna]) == 0:
                        return False

        return True
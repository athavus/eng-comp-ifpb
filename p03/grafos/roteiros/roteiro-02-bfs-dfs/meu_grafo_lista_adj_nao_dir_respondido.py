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

        nao_adjacentes = set()

        vertices = self.vertices

        for i in range(len(vertices)):
            for j in range(i + 1, len(vertices)):
                v1 = vertices[i].rotulo
                v2 = vertices[j].rotulo

                adjacente = False
                for aresta in self.arestas.values():
                    if (aresta.v1.rotulo == v1 and aresta.v2.rotulo == v2) or (aresta.v1.rotulo == v2 and aresta.v2.rotulo == v1):
                        adjacente = True
                        break

                if not adjacente:
                    nao_adjacentes.add(f"{v1}-{v2}")

        return nao_adjacentes

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

        vertices_completos = []

        if self.ha_laco() or self.ha_paralelas():
            return False

        for vertice in self.vertices:
            cont = 0
            for aresta in self.arestas.values():
                if aresta.v1.rotulo == vertice.rotulo or aresta.v2.rotulo == vertice.rotulo:
                    cont += 1
            if cont == len(self.vertices) - 1:
                vertices_completos.append(vertice)

        if len(vertices_completos) == len(self.vertices):
            return True

    def dfs(self, V=""):
        '''
        Provê uma lista com os vértices acessíveis a partir do vértice V em uma busca em profundidade (DFS).
        A lista contém os vértices visitados na ordem em que foram visitados pela busca.
        :param V: O vértice inicial
        :return: Uma lista com os rótulos dos vértices acessíveis a partir de V
        :raises: VerticeInvalidoError se o vértice não existe no grafo
        '''
        if not self.existe_rotulo_vertice(V):
            raise VerticeInvalidoError("")

        visitados = []
        arvore_dfs = MeuGrafo()

        arvore_dfs.adiciona_vertice(V)

        def dfs_recursivo(vertice_atual):
            if vertice_atual not in visitados:
                visitados.append(vertice_atual)

                arestas_incidentes = sorted(self.arestas_sobre_vertice(vertice_atual))

                for aresta in arestas_incidentes:
                    v1 = self.arestas[aresta].v1.rotulo
                    v2 = self.arestas[aresta].v2.rotulo

                    if v1 == vertice_atual:
                        vertice_adjacente = v2
                    else:
                        vertice_adjacente = v1

                    if vertice_adjacente not in visitados:
                        if not arvore_dfs.existe_rotulo_vertice(vertice_adjacente):
                            arvore_dfs.adiciona_vertice(vertice_adjacente)

                        arvore_dfs.adiciona_aresta(aresta, vertice_atual, vertice_adjacente)

                        dfs_recursivo(vertice_adjacente)

        dfs_recursivo(V)

        return arvore_dfs

    def bfs(self, V=""):
        '''
        Provê uma lista com os vértices acessíveis a partir do vértice V em uma busca em largura (BFS).
        A lista contém os vértices visitados na ordem em que foram visitados pela busca.
        :param V: O vértice inicial
        :return: Uma lista com os rótulos dos vértices acessíveis a partir de V
        :raises: VerticeInvalidoError se o vértice não existe no grafo
        '''
        if not self.existe_rotulo_vertice(V):
            raise VerticeInvalidoError("")

        visitados = []
        fila = [V]
        arvore_bfs = MeuGrafo()

        arvore_bfs.adiciona_vertice(V)

        while fila:
            vertice_atual = fila.pop(0)

            if vertice_atual not in visitados:
                visitados.append(vertice_atual)

                arestas_incidentes = sorted(self.arestas_sobre_vertice(vertice_atual))

                for aresta in arestas_incidentes:
                    v1 = self.arestas[aresta].v1.rotulo
                    v2 = self.arestas[aresta].v2.rotulo

                    if v1 == vertice_atual:
                        vertice_adjacente = v2
                    else:
                        vertice_adjacente = v1

                    if vertice_adjacente not in visitados and vertice_adjacente not in fila:
                        fila.append(vertice_adjacente)

                        if not arvore_bfs.existe_rotulo_vertice(vertice_adjacente):
                            arvore_bfs.adiciona_vertice(vertice_adjacente)

                        arvore_bfs.adiciona_aresta(aresta, vertice_atual, vertice_adjacente)

        return arvore_bfs

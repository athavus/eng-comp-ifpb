from bibgrafo.grafo_matriz_adj_dir import *
from bibgrafo.grafo_errors import *
from copy import deepcopy
from math import inf


class MeuGrafo(GrafoMatrizAdjacenciaDirecionado):

    def vertices_nao_adjacentes(self):
        '''
        Provê uma lista de vértices não adjacentes no grafo. A lista terá o seguinte formato: [X-Z, X-W, ...]
        Onde X, Z e W são vértices no grafo que não tem uma aresta entre eles.
        :return: Uma lista com os pares de vértices não adjacentes
        '''
        resultado = []
        tam = len(self.matriz)
        for linha in range(tam):
            for coluna in range(tam):
                if linha != coluna and not self.matriz[linha][coluna]:
                    par = f"{self.vertices[linha].rotulo}-{self.vertices[coluna].rotulo}"
                    resultado.append(par)
        return resultado

    def ha_laco(self):
        '''
        Verifica se existe algum laço no grafo.
        :return: Um valor booleano que indica se existe algum laço.
        '''
        for idx in range(len(self.vertices)):
            if self.matriz[idx][idx]:
                return True
        return False

    def grau_entrada(self, V=''):
        '''
        Provê o grau do vértice passado como parâmetro
        :param V: O rótulo do vértice a ser analisado
        :return: Um valor inteiro que indicates o grau do vértice
        :raises: VerticeInvalidoException se o vértice não existe no grafo
        '''
        pos = self.indice_do_vertice(self.get_vertice(V))
        total = 0
        for linha in range(len(self.matriz)):
            total += len(self.matriz[linha][pos])
        return total

    def grau_saida(self, V=''):
        '''
        Provê o grau do vértice passado como parâmetro
        :param V: O rótulo do vértice a ser analisado
        :return: Um valor inteiro que indica o grau do vértice
        :raises: VerticeInvalidoException se o vértice não existe no grafo
        '''
        pos = self.indice_do_vertice(self.get_vertice(V))
        total = 0
        for coluna in range(len(self.matriz)):
            total += len(self.matriz[pos][coluna])
        return total

    def ha_paralelas(self):
        '''
        Verifica se há arestas paralelas no grafo
        :return: Um valor booleano que indica se existem arestas paralelas no grafo.
        '''
        for linha in self.matriz:
            for celula in linha:
                if len(celula) > 1:
                    return True
        return False

    def arestas_sobre_vertice(self, V):
        '''
        Provê uma lista que contém os rótulos das arestas que incidem sobre o vértice passado como parâmetro
        :param V: O vértice a ser analisado
        :return: Uma lista os rótulos das arestas que incidem sobre o vértice
        :raises: VerticeInvalidoException se o vértice não existe no grafo
        '''
        arestas_incidentes = set()
        pos = self.indice_do_vertice(self.get_vertice(V))

        for idx in range(len(self.matriz)):
            for aresta in self.matriz[idx][pos]:
                arestas_incidentes.add(aresta)
            for aresta in self.matriz[pos][idx]:
                arestas_incidentes.add(aresta)

        return arestas_incidentes

    def eh_completo(self):
        '''
        Verifica se o grafo é completo.
        :return: Um valor booleano que indica se o grafo é completo
        '''
        return (not self.vertices_nao_adjacentes() and
                not self.ha_laco() and
                not self.ha_paralelas())

    def warshall(self):
        '''
        Provê a matriz de alcançabilidade de Warshall do grafo
        :return: Uma lista de listas que representa a matriz de alcançabilidade de Warshall associada ao grafo
        '''
        matriz_warshall = deepcopy(self.matriz)
        n = len(matriz_warshall)

        for i in range(n):
            for j in range(n):
                matriz_warshall[i][j] = bool(matriz_warshall[i][j])

        for k in range(n):
            for i in range(n):
                if matriz_warshall[i][k]:
                    for j in range(n):
                        matriz_warshall[i][j] = matriz_warshall[i][j] or matriz_warshall[k][j]

        return matriz_warshall

    def Dijkstra(self, ve="", vs=""):
        def encontrar_caminho(origem, destino, predecessor):
            if origem == destino:
                return [destino]

            caminho_completo = [destino]
            atual = destino

            while atual != origem:
                vertice_anterior, aresta_anterior = predecessor[atual]
                caminho_completo = [vertice_anterior, aresta_anterior] + caminho_completo
                atual = vertice_anterior

            return caminho_completo

        def buscar_recursivo(vertice_atual):
            if vertice_atual == vs:
                return True

            visitado[vertice_atual] = True
            pos_atual = self.indice_do_vertice(self.get_vertice(vertice_atual))

            for coluna in range(len(self.matriz)):
                for aresta_rotulo in self.matriz[pos_atual][coluna]:
                    aresta = self.matriz[pos_atual][coluna][aresta_rotulo]
                    v_destino = aresta.v2.rotulo
                    nova_distancia = distancia[vertice_atual] + aresta.peso

                    if nova_distancia < distancia[v_destino]:
                        distancia[v_destino] = nova_distancia
                        predecessor[v_destino] = [vertice_atual, aresta.rotulo]

            proximo_vertice = None
            menor_dist = float('inf')

            for v in self.vertices:
                rotulo = v.rotulo
                if not visitado[rotulo] and distancia[rotulo] < menor_dist:
                    menor_dist = distancia[rotulo]
                    proximo_vertice = rotulo

            if proximo_vertice is None:
                return False

            return buscar_recursivo(proximo_vertice)

        distancia = {v.rotulo: float('inf') for v in self.vertices}
        visitado = {v.rotulo: False for v in self.vertices}
        predecessor = {}

        distancia[ve] = 0

        if buscar_recursivo(ve):
            return encontrar_caminho(ve, vs, predecessor)

        return False

    def bellman_ford(self, vi='', vf=''):
        num_vertices = len(self.vertices)
        tabela_distancias = []

        linha_inicial = [float('inf')] * num_vertices
        tabela_distancias.append(linha_inicial)

        idx_origem = self.indice_do_vertice(self.get_vertice(vi))
        tabela_distancias[0][idx_origem] = 0

        predecessores = {}
        convergiu = False

        for iteracao in range(1, num_vertices):
            linha_anterior = tabela_distancias[iteracao - 1].copy()
            tabela_distancias.append(linha_anterior)

            for idx_vertice in range(num_vertices):
                if idx_vertice == idx_origem:
                    tabela_distancias[iteracao][idx_origem] = 0

                if tabela_distancias[iteracao][idx_vertice] != float('inf'):
                    for coluna in range(len(self.matriz)):
                        for aresta_rotulo in self.matriz[idx_vertice][coluna]:
                            aresta = self.matriz[idx_vertice][coluna][aresta_rotulo]
                            idx_destino = self.indice_do_vertice(self.get_vertice(aresta.v2.rotulo))
                            custo_novo = tabela_distancias[iteracao][idx_vertice] + aresta.peso

                            if custo_novo < tabela_distancias[iteracao][idx_destino]:
                                tabela_distancias[iteracao][idx_destino] = custo_novo
                                predecessores[aresta.v2.rotulo] = [aresta.v1.rotulo, aresta.rotulo]

            if tabela_distancias[iteracao] == tabela_distancias[iteracao - 1]:
                convergiu = True
                break

        idx_destino = self.indice_do_vertice(self.get_vertice(vf))

        if convergiu and tabela_distancias[-1][idx_destino] != float('inf'):
            if vi == vf:
                return [vf]

            caminho_final = [vf]
            vertice_atual = vf

            while vertice_atual != vi:
                v_anterior, a_anterior = predecessores[vertice_atual]
                caminho_final = [v_anterior, a_anterior] + caminho_final
                vertice_atual = v_anterior

            return caminho_final

        return False
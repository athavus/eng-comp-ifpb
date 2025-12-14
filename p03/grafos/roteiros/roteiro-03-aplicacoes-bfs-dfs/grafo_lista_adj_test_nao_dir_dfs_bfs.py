import unittest
from meu_grafo_lista_adj_nao_dir import *
import gerar_grafos_teste
from bibgrafo.aresta import Aresta
from bibgrafo.vertice import Vertice
from bibgrafo.grafo_errors import *
from bibgrafo.grafo_json import GrafoJSON
from bibgrafo.grafo_builder import GrafoBuilder


class TestGrafo(unittest.TestCase):

    def setUp(self):
        # Grafo da Paraíba
        self.g_p = GrafoJSON.json_to_grafo('test_json/grafo_pb.json', MeuGrafo())

        # Clone do Grafo da Paraíba para ver se o método equals está funcionando
        self.g_p2 = GrafoJSON.json_to_grafo('test_json/grafo_pb2.json', MeuGrafo())

        # Outro clone do Grafo da Paraíba para ver se o método equals está funcionando
        # Esse tem um pequena diferença na primeira aresta
        self.g_p3 = GrafoJSON.json_to_grafo('test_json/grafo_pb3.json', MeuGrafo())

        # Outro clone do Grafo da Paraíba para ver se o método equals está funcionando
        # Esse tem um pequena diferença na segunda aresta
        self.g_p4 = GrafoJSON.json_to_grafo('test_json/grafo_pb4.json', MeuGrafo())

        # Grafo da Paraíba sem arestas paralelas
        self.g_p_sem_paralelas = MeuGrafo()
        self.g_p_sem_paralelas.adiciona_vertice("J")
        self.g_p_sem_paralelas.adiciona_vertice("C")
        self.g_p_sem_paralelas.adiciona_vertice("E")
        self.g_p_sem_paralelas.adiciona_vertice("P")
        self.g_p_sem_paralelas.adiciona_vertice("M")
        self.g_p_sem_paralelas.adiciona_vertice("T")
        self.g_p_sem_paralelas.adiciona_vertice("Z")
        self.g_p_sem_paralelas.adiciona_aresta('a1', 'J', 'C')
        self.g_p_sem_paralelas.adiciona_aresta('a2', 'C', 'E')
        self.g_p_sem_paralelas.adiciona_aresta('a3', 'P', 'C')
        self.g_p_sem_paralelas.adiciona_aresta('a4', 'T', 'C')
        self.g_p_sem_paralelas.adiciona_aresta('a5', 'M', 'C')
        self.g_p_sem_paralelas.adiciona_aresta('a6', 'M', 'T')
        self.g_p_sem_paralelas.adiciona_aresta('a7', 'T', 'Z')

        # Grafos completos
        self.g_c = GrafoBuilder().tipo(MeuGrafo()) \
            .vertices(['J', 'C', 'E', 'P']).arestas(True).build()

        self.g_c2 = GrafoBuilder().tipo(MeuGrafo()) \
            .vertices(3).arestas(True).build()

        self.g_c3 = GrafoBuilder().tipo(MeuGrafo()) \
            .vertices(1).build()

        # Grafos com laco
        self.g_l1 = GrafoJSON.json_to_grafo('test_json/grafo_l1.json', MeuGrafo())

        self.g_l2 = GrafoJSON.json_to_grafo('test_json/grafo_l2.json', MeuGrafo())

        self.g_l3 = GrafoJSON.json_to_grafo('test_json/grafo_l3.json', MeuGrafo())

        self.g_l4 = GrafoBuilder().tipo(MeuGrafo()).vertices([v:=Vertice('D')]) \
            .arestas([Aresta('a1', v, v)]).build()

        self.g_l5 = GrafoBuilder().tipo(MeuGrafo()).vertices(3) \
            .arestas(3, lacos=1).build()

        # Grafos desconexos
        self.g_d = GrafoBuilder().tipo(MeuGrafo()) \
            .vertices([a:=Vertice('A'), b:=Vertice('B'), Vertice('C'), Vertice('D')]) \
            .arestas([Aresta('asd', a, b)]).build()

        self.g_d2 = GrafoBuilder().tipo(MeuGrafo()).vertices(4).build()

        # Grafo p\teste de remoção em casta
        self.g_r = GrafoBuilder().tipo(MeuGrafo()).vertices(2).arestas(1).build()

    def test_adiciona_aresta(self):
        self.assertTrue(self.g_p.adiciona_aresta('a10', 'J', 'C'))
        a = Aresta("zxc", self.g_p.get_vertice("C"), self.g_p.get_vertice("Z"))
        self.assertTrue(self.g_p.adiciona_aresta(a))
        with self.assertRaises(ArestaInvalidaError):
            self.assertTrue(self.g_p.adiciona_aresta(a))
        with self.assertRaises(VerticeInvalidoError):
            self.assertTrue(self.g_p.adiciona_aresta('b1', '', 'C'))
        with self.assertRaises(VerticeInvalidoError):
            self.assertTrue(self.g_p.adiciona_aresta('b1', 'A', 'C'))
        with self.assertRaises(TypeError):
            self.g_p.adiciona_aresta('')
        with self.assertRaises(TypeError):
            self.g_p.adiciona_aresta('aa-bb')
        with self.assertRaises(VerticeInvalidoError):
            self.g_p.adiciona_aresta('x', 'J', 'V')
        with self.assertRaises(ArestaInvalidaError):
            self.g_p.adiciona_aresta('a1', 'J', 'C')

    def test_remove_vertice(self):
        self.assertIsNone(self.g_r.remove_vertice('A'))
        self.assertFalse(self.g_r.existe_rotulo_vertice('A'))
        self.assertFalse(self.g_r.existe_rotulo_aresta('1'))
        with self.assertRaises(VerticeInvalidoError):
            self.g_r.get_vertice('A')
        self.assertFalse(self.g_r.get_aresta('1'))
        self.assertEqual(self.g_r.arestas_sobre_vertice('B'), set())

    def test_eq(self):
        self.assertEqual(self.g_p, self.g_p2)
        self.assertNotEqual(self.g_p, self.g_p3)
        self.assertNotEqual(self.g_p, self.g_p_sem_paralelas)
        self.assertNotEqual(self.g_p, self.g_p4)

    def test_vertices_nao_adjacentes(self):
        self.assertEqual(self.g_p.vertices_nao_adjacentes(),
                         {'J-E', 'J-P', 'J-M', 'J-T', 'J-Z', 'C-Z', 'E-P', 'E-M', 'E-T', 'E-Z', 'P-M', 'P-T', 'P-Z',
                          'M-Z'})
        self.assertEqual(self.g_d.vertices_nao_adjacentes(), {'A-C', 'A-D', 'B-C', 'B-D', 'C-D'})
        self.assertEqual(self.g_d2.vertices_nao_adjacentes(), {'A-B', 'A-C', 'A-D', 'B-C', 'B-D', 'C-D'})
        self.assertEqual(self.g_c.vertices_nao_adjacentes(), set())
        self.assertEqual(self.g_c3.vertices_nao_adjacentes(), set())

    def test_ha_laco(self):
        self.assertFalse(self.g_p.ha_laco())
        self.assertFalse(self.g_p2.ha_laco())
        self.assertFalse(self.g_p3.ha_laco())
        self.assertFalse(self.g_p4.ha_laco())
        self.assertFalse(self.g_p_sem_paralelas.ha_laco())
        self.assertFalse(self.g_d.ha_laco())
        self.assertFalse(self.g_c.ha_laco())
        self.assertFalse(self.g_c2.ha_laco())
        self.assertFalse(self.g_c3.ha_laco())
        self.assertTrue(self.g_l1.ha_laco())
        self.assertTrue(self.g_l2.ha_laco())
        self.assertTrue(self.g_l3.ha_laco())
        self.assertTrue(self.g_l4.ha_laco())
        self.assertTrue(self.g_l5.ha_laco())

    def test_grau(self):
        # Paraíba
        self.assertEqual(self.g_p.grau('J'), 1)
        self.assertEqual(self.g_p.grau('C'), 7)
        self.assertEqual(self.g_p.grau('E'), 2)
        self.assertEqual(self.g_p.grau('P'), 2)
        self.assertEqual(self.g_p.grau('M'), 2)
        self.assertEqual(self.g_p.grau('T'), 3)
        self.assertEqual(self.g_p.grau('Z'), 1)
        with self.assertRaises(VerticeInvalidoError):
            self.assertEqual(self.g_p.grau('G'), 5)

        self.assertEqual(self.g_d.grau('A'), 1)
        self.assertEqual(self.g_d.grau('C'), 0)
        self.assertNotEqual(self.g_d.grau('D'), 2)
        self.assertEqual(self.g_d2.grau('A'), 0)

        # Completos
        self.assertEqual(self.g_c.grau('J'), 3)
        self.assertEqual(self.g_c.grau('C'), 3)
        self.assertEqual(self.g_c.grau('E'), 3)
        self.assertEqual(self.g_c.grau('P'), 3)

        # Com laço. Lembrando que cada laço conta 2 vezes por vértice para cálculo do grau
        self.assertEqual(self.g_l1.grau('A'), 5)
        self.assertEqual(self.g_l2.grau('B'), 4)
        self.assertEqual(self.g_l4.grau('D'), 2)

    def test_ha_paralelas(self):
        self.assertTrue(self.g_p.ha_paralelas())
        self.assertFalse(self.g_p_sem_paralelas.ha_paralelas())
        self.assertFalse(self.g_c.ha_paralelas())
        self.assertFalse(self.g_c2.ha_paralelas())
        self.assertFalse(self.g_c3.ha_paralelas())
        self.assertTrue(self.g_l1.ha_paralelas())

    def test_arestas_sobre_vertice(self):
        self.assertEqual(self.g_p.arestas_sobre_vertice('J'), {'a1'})
        self.assertEqual(self.g_p.arestas_sobre_vertice('C'), {'a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7'})
        self.assertEqual(self.g_p.arestas_sobre_vertice('M'), {'a7', 'a8'})
        self.assertEqual(self.g_l2.arestas_sobre_vertice('B'), {'a1', 'a2', 'a3'})
        self.assertEqual(self.g_d.arestas_sobre_vertice('C'), set())
        self.assertEqual(self.g_d.arestas_sobre_vertice('A'), {'asd'})
        with self.assertRaises(VerticeInvalidoError):
            self.g_p.arestas_sobre_vertice('A')

    def test_eh_completo(self):
        self.assertFalse(self.g_p.eh_completo())
        self.assertFalse((self.g_p_sem_paralelas.eh_completo()))
        self.assertTrue((self.g_c.eh_completo()))
        self.assertTrue((self.g_c2.eh_completo()))
        self.assertTrue((self.g_c3.eh_completo()))
        self.assertFalse((self.g_l1.eh_completo()))
        self.assertFalse((self.g_l2.eh_completo()))
        self.assertFalse((self.g_l3.eh_completo()))
        self.assertFalse((self.g_l4.eh_completo()))
        self.assertFalse((self.g_l5.eh_completo()))
        self.assertFalse((self.g_d.eh_completo()))
        self.assertFalse((self.g_d2.eh_completo()))

    def test_dfs(self):
        # Teste DFS no grafo da Paraíba
        arvore_dfs_j = self.g_p.dfs('J')
        self.assertTrue(arvore_dfs_j.existe_rotulo_vertice('J'))
        self.assertTrue(arvore_dfs_j.existe_rotulo_vertice('C'))
        self.assertEqual(len(list(arvore_dfs_j.vertices)), 7)

        # Teste DFS a partir do vértice central
        arvore_dfs_c = self.g_p.dfs('C')
        self.assertEqual(len(list(arvore_dfs_c.vertices)), 7)

        # Teste com grafo desconexo
        arvore_dfs_desc = self.g_d.dfs('A')
        self.assertEqual(len(list(arvore_dfs_desc.vertices)), 2)

        # Teste com vértice isolado
        arvore_dfs_isolado = self.g_d.bfs('C')
        self.assertEqual(len(list(arvore_dfs_isolado.vertices)), 1)

        # Teste com grafo completo
        arvore_dfs_completo = self.g_c.dfs('J')
        self.assertEqual(len(list(arvore_dfs_completo.vertices)), 4)

        # Verificar que não tem laços ou paralelas na árvore
        self.assertFalse(arvore_dfs_j.ha_laco())
        self.assertFalse(arvore_dfs_j.ha_paralelas())

        # Teste com vértice inválido
        with self.assertRaises(VerticeInvalidoError):
            self.g_p.dfs('X')


    def test_bfs(self):
        # Teste BFS no grafo da Paraíba
        arvore_bfs_j = self.g_p.bfs('J')
        self.assertTrue(arvore_bfs_j.existe_rotulo_vertice('J'))
        self.assertTrue(arvore_bfs_j.existe_rotulo_vertice('C'))
        self.assertEqual(len(list(arvore_bfs_j.vertices)), 7)

        # Teste BFS a partir do vértice central
        arvore_bfs_c = self.g_p.bfs('C')
        self.assertEqual(len(list(arvore_bfs_c.vertices)), 7)

        # Teste com grafo desconexo
        arvore_bfs_desc = self.g_d.bfs('A')
        self.assertEqual(len(list(arvore_bfs_desc.vertices)), 2)

        # Teste com vértice isolado
        arvore_bfs_isolado = self.g_d.bfs('C')
        self.assertEqual(len(list(arvore_bfs_isolado.vertices)), 1)

        # Teste com grafo completo
        arvore_bfs_completo = self.g_c.bfs('J')
        self.assertEqual(len(list(arvore_bfs_completo.vertices)), 4)

        # Verificar que não tem laços ou paralelas na árvore
        self.assertFalse(arvore_bfs_j.ha_laco())
        self.assertFalse(arvore_bfs_j.ha_paralelas())

        # Teste com vértice inválido
        with self.assertRaises(VerticeInvalidoError):
            self.g_p.bfs('X')

    def test_ha_ciclo(self):
        # Teste com grafo da Paraíba (tem ciclos)
        self.assertTrue(self.g_p.ha_ciclo())

        # Teste com grafo sem paralelas (tem ciclos)
        self.assertTrue(self.g_p_sem_paralelas.ha_ciclo())

        # Teste com grafos completos (têm ciclos)
        self.assertTrue(self.g_c.ha_ciclo())
        self.assertTrue(self.g_c2.ha_ciclo())

        # Teste com grafo completo de 1 vértice (não tem ciclo)
        self.assertFalse(self.g_c3.ha_ciclo())

        # Teste com grafos desconexos
        self.assertFalse(self.g_d.ha_ciclo())  # Só tem uma aresta, não forma ciclo
        self.assertFalse(self.g_d2.ha_ciclo())  # Sem arestas, não tem ciclo

        # Teste com grafos com laço (laços são ciclos)
        self.assertTrue(self.g_l1.ha_ciclo())
        self.assertTrue(self.g_l2.ha_ciclo())
        self.assertTrue(self.g_l3.ha_ciclo())
        self.assertTrue(self.g_l4.ha_ciclo())
        self.assertTrue(self.g_l5.ha_ciclo())

        # Criando uma árvore simples para teste (sem ciclo)
        arvore_simples = MeuGrafo()
        arvore_simples.adiciona_vertice("A")
        arvore_simples.adiciona_vertice("B")
        arvore_simples.adiciona_vertice("C")
        arvore_simples.adiciona_aresta('ab', 'A', 'B')
        arvore_simples.adiciona_aresta('bc', 'B', 'C')
        self.assertFalse(arvore_simples.ha_ciclo())

    def test_eh_arvore(self):
        # Teste com grafo da Paraíba (não é árvore - tem ciclos)
        self.assertFalse(self.g_p.eh_arvore())

        # Teste com grafo sem paralelas (não é árvore - tem ciclos)
        self.assertFalse(self.g_p_sem_paralelas.eh_arvore())

        # Teste com grafos completos (não são árvores - têm ciclos)
        self.assertFalse(self.g_c.eh_arvore())
        self.assertFalse(self.g_c2.eh_arvore())

        # Teste com grafo completo de 1 vértice (é árvore)
        resultado_c3 = self.g_c3.eh_arvore()
        self.assertTrue(isinstance(resultado_c3, list))  # Retorna lista de folhas
        self.assertEqual(len(resultado_c3), 1)  # Uma folha (o próprio vértice)

        # Teste com grafos desconexos (não são árvores)
        self.assertFalse(self.g_d.eh_arvore())  # Desconexo
        self.assertFalse(self.g_d2.eh_arvore())  # Desconexo (sem arestas)

        # Teste com grafos com laço (não são árvores)
        self.assertFalse(self.g_l1.eh_arvore())
        self.assertFalse(self.g_l2.eh_arvore())
        self.assertFalse(self.g_l3.eh_arvore())
        self.assertFalse(self.g_l4.eh_arvore())
        self.assertFalse(self.g_l5.eh_arvore())

        # Criando uma árvore simples
        arvore_simples = MeuGrafo()
        arvore_simples.adiciona_vertice("A")
        arvore_simples.adiciona_vertice("B")
        arvore_simples.adiciona_vertice("C")
        arvore_simples.adiciona_aresta('ab', 'A', 'B')
        arvore_simples.adiciona_aresta('bc', 'B', 'C')
        resultado_arvore = arvore_simples.eh_arvore()
        self.assertTrue(isinstance(resultado_arvore, list))
        self.assertEqual(set(resultado_arvore), {'A', 'C'})  # A e C são folhas

        # Criando uma árvore estrela (vértice central conectado a vários)
        arvore_estrela = MeuGrafo()
        arvore_estrela.adiciona_vertice("CENTRO")
        arvore_estrela.adiciona_vertice("F1")
        arvore_estrela.adiciona_vertice("F2")
        arvore_estrela.adiciona_vertice("F3")
        arvore_estrela.adiciona_aresta('e1', 'CENTRO', 'F1')
        arvore_estrela.adiciona_aresta('e2', 'CENTRO', 'F2')
        arvore_estrela.adiciona_aresta('e3', 'CENTRO', 'F3')
        resultado_estrela = arvore_estrela.eh_arvore()
        self.assertTrue(isinstance(resultado_estrela, list))
        self.assertEqual(set(resultado_estrela), {'F1', 'F2', 'F3'})  # As folhas

    def test_eh_bipartido(self):
        # Teste com grafo vazio
        grafo_vazio = MeuGrafo()
        self.assertTrue(grafo_vazio.eh_bipartido())

        # Teste com grafo de um vértice
        self.assertTrue(self.g_c3.eh_bipartido())

        # Teste com grafo desconexo sem arestas
        self.assertTrue(self.g_d2.eh_bipartido())

        # Teste com grafo desconexo com uma aresta
        self.assertTrue(self.g_d.eh_bipartido())  # Uma aresta é sempre bipartida

        # Criando um grafo bipartido simples (grafo estrela)
        grafo_estrela = MeuGrafo()
        grafo_estrela.adiciona_vertice("CENTRO")
        grafo_estrela.adiciona_vertice("A")
        grafo_estrela.adiciona_vertice("B")
        grafo_estrela.adiciona_vertice("C")
        grafo_estrela.adiciona_aresta('ca', 'CENTRO', 'A')
        grafo_estrela.adiciona_aresta('cb', 'CENTRO', 'B')
        grafo_estrela.adiciona_aresta('cc', 'CENTRO', 'C')
        self.assertTrue(grafo_estrela.eh_bipartido())

        # Criando um grafo bipartido completo K2,2
        grafo_k22 = MeuGrafo()
        grafo_k22.adiciona_vertice("A1")
        grafo_k22.adiciona_vertice("A2")
        grafo_k22.adiciona_vertice("B1")
        grafo_k22.adiciona_vertice("B2")
        grafo_k22.adiciona_aresta('a1b1', 'A1', 'B1')
        grafo_k22.adiciona_aresta('a1b2', 'A1', 'B2')
        grafo_k22.adiciona_aresta('a2b1', 'A2', 'B1')
        grafo_k22.adiciona_aresta('a2b2', 'A2', 'B2')
        self.assertTrue(grafo_k22.eh_bipartido())

        # Criando um grafo não bipartido (triângulo)
        triangulo = MeuGrafo()
        triangulo.adiciona_vertice("X")
        triangulo.adiciona_vertice("Y")
        triangulo.adiciona_vertice("Z")
        triangulo.adiciona_aresta('xy', 'X', 'Y')
        triangulo.adiciona_aresta('yz', 'Y', 'Z')
        triangulo.adiciona_aresta('zx', 'Z', 'X')
        self.assertFalse(triangulo.eh_bipartido())

        # Teste com grafos completos
        self.assertFalse(self.g_c.eh_bipartido())  # K4 não é bipartido
        self.assertFalse(self.g_c2.eh_bipartido())  # K3 não é bipartido

        # Teste com grafo da Paraíba (precisa verificar se é bipartido)
        # O grafo da Paraíba tem a estrutura de uma estrela com algumas conexões extras
        # Como tem ciclos ímpares, provavelmente não é bipartido
        self.assertFalse(self.g_p.eh_bipartido())
        self.assertFalse(self.g_p_sem_paralelas.eh_bipartido())

        # Teste com grafos com laço (não são bipartidos)
        self.assertFalse(self.g_l1.eh_bipartido())
        self.assertFalse(self.g_l2.eh_bipartido())
        self.assertFalse(self.g_l3.eh_bipartido())
        self.assertFalse(self.g_l4.eh_bipartido())
        self.assertFalse(self.g_l5.eh_bipartido())

        # Criando um caminho (sempre bipartido)
        caminho = MeuGrafo()
        caminho.adiciona_vertice("P1")
        caminho.adiciona_vertice("P2")
        caminho.adiciona_vertice("P3")
        caminho.adiciona_vertice("P4")
        caminho.adiciona_aresta('p12', 'P1', 'P2')
        caminho.adiciona_aresta('p23', 'P2', 'P3')
        caminho.adiciona_aresta('p34', 'P3', 'P4')
        self.assertTrue(caminho.eh_bipartido())

        # Criando um ciclo par (bipartido)
        ciclo_par = MeuGrafo()
        ciclo_par.adiciona_vertice("C1")
        ciclo_par.adiciona_vertice("C2")
        ciclo_par.adiciona_vertice("C3")
        ciclo_par.adiciona_vertice("C4")
        ciclo_par.adiciona_aresta('c12', 'C1', 'C2')
        ciclo_par.adiciona_aresta('c23', 'C2', 'C3')
        ciclo_par.adiciona_aresta('c34', 'C3', 'C4')
        ciclo_par.adiciona_aresta('c41', 'C4', 'C1')
        self.assertTrue(ciclo_par.eh_bipartido())

        # Criando um ciclo ímpar (não bipartido)
        ciclo_impar = MeuGrafo()
        ciclo_impar.adiciona_vertice("I1")
        ciclo_impar.adiciona_vertice("I2")
        ciclo_impar.adiciona_vertice("I3")
        ciclo_impar.adiciona_vertice("I4")
        ciclo_impar.adiciona_vertice("I5")
        ciclo_impar.adiciona_aresta('i12', 'I1', 'I2')
        ciclo_impar.adiciona_aresta('i23', 'I2', 'I3')
        ciclo_impar.adiciona_aresta('i34', 'I3', 'I4')
        ciclo_impar.adiciona_aresta('i45', 'I4', 'I5')
        ciclo_impar.adiciona_aresta('i51', 'I5', 'I1')
        self.assertFalse(ciclo_impar.eh_bipartido())
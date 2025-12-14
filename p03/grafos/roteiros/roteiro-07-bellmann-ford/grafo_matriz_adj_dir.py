import unittest
from bibgrafo.aresta import ArestaDirecionada
from bibgrafo.grafo_errors import VerticeInvalidoError, ArestaInvalidaError
from bibgrafo.grafo_json import GrafoJSON
from bibgrafo.grafo_builder import GrafoBuilder
from meu_grafo_matriz_adj_dir import *

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
        self.g_p_sem_paralelas = GrafoJSON.json_to_grafo('test_json/grafo_pb_simples.json', MeuGrafo())

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

        self.g_l4 = GrafoBuilder().tipo(MeuGrafo()).vertices([(v:=Vertice('D'))]) \
            .arestas([ArestaDirecionada('a1', v, v)]).build()

        self.g_l5 = GrafoBuilder().tipo(MeuGrafo()).vertices(3) \
            .arestas(3, lacos=1).build()

        # Grafos desconexos
        self.g_d = GrafoBuilder().tipo(MeuGrafo()) \
            .vertices([a:=Vertice('A'), b:=Vertice('B'), Vertice('C'), Vertice('D')]) \
            .arestas([ArestaDirecionada('asd', a, b)]).build()

        self.g_d2 = GrafoBuilder().tipo(MeuGrafo()).vertices(4).build()

        # Grafo com ciclos e laços
        self.g_e = MeuGrafo()
        self.g_e.adiciona_vertice("A")
        self.g_e.adiciona_vertice("B")
        self.g_e.adiciona_vertice("C")
        self.g_e.adiciona_vertice("D")
        self.g_e.adiciona_vertice("E")
        self.g_e.adiciona_aresta('1', 'A', 'B')
        self.g_e.adiciona_aresta('2', 'A', 'C')
        self.g_e.adiciona_aresta('3', 'C', 'A')
        self.g_e.adiciona_aresta('4', 'C', 'B')
        self.g_e.adiciona_aresta('10', 'C', 'B')
        self.g_e.adiciona_aresta('5', 'C', 'D')
        self.g_e.adiciona_aresta('6', 'D', 'D')
        self.g_e.adiciona_aresta('7', 'D', 'B')
        self.g_e.adiciona_aresta('8', 'D', 'E')
        self.g_e.adiciona_aresta('9', 'E', 'A')
        self.g_e.adiciona_aresta('11', 'E', 'B')

        self.g_ex = MeuGrafo()
        self.g_ex.adiciona_vertice("A")
        self.g_ex.adiciona_vertice("B")
        self.g_ex.adiciona_vertice("C")
        self.g_ex.adiciona_vertice("D")
        self.g_ex.adiciona_vertice("E")
        self.g_ex.adiciona_aresta('1','A','B')
        self.g_ex.adiciona_aresta('2', 'A', 'C')
        self.g_ex.adiciona_aresta('3', 'C', 'E')
        self.g_ex.adiciona_aresta('4', 'E', 'A')
        self.g_ex.adiciona_aresta('5', 'D', 'E')
        self.g_ex.adiciona_aresta('1', 'D', 'A')

        self.g_ex2 = MeuGrafo()
        self.g_ex2.adiciona_vertice("A")
        self.g_ex2.adiciona_vertice("B")
        self.g_ex2.adiciona_vertice("C")
        self.g_ex2.adiciona_vertice("D")
        self.g_ex2.adiciona_vertice("E")
        self.g_ex2.adiciona_vertice("F")
        self.g_ex2.adiciona_aresta('1', 'A', 'F')
        self.g_ex2.adiciona_aresta('2', 'B', 'A')
        self.g_ex2.adiciona_aresta('3', 'C', 'A')
        self.g_ex2.adiciona_aresta('4', 'C', 'D')
        self.g_ex2.adiciona_aresta('5', 'D', 'B')
        self.g_ex2.adiciona_aresta('6', 'D', 'E')
        self.g_ex2.adiciona_aresta('7', 'E', 'D')

        self.g_ex3 = MeuGrafo()
        self.g_ex3.adiciona_vertice("A")
        self.g_ex3.adiciona_vertice("B")
        self.g_ex3.adiciona_vertice("C")
        self.g_ex3.adiciona_vertice("D")
        self.g_ex3.adiciona_vertice("E")
        self.g_ex3.adiciona_vertice("F")
        self.g_ex3.adiciona_vertice("G")
        self.g_ex3.adiciona_vertice("H")
        self.g_ex3.adiciona_aresta("a1", "A", "B")
        self.g_ex3.adiciona_aresta("a2", "A", "C")
        self.g_ex3.adiciona_aresta("a3", "B", "D")
        self.g_ex3.adiciona_aresta("a4", "B", "E")
        self.g_ex3.adiciona_aresta("a5", "C", "F")
        self.g_ex3.adiciona_aresta("a6", "G", "C")
        self.g_ex3.adiciona_aresta("a7", "D", "H")
        self.g_ex3.adiciona_aresta("a8", "E", "H")
        self.g_ex3.adiciona_aresta("a9", "F", "B")
        self.g_ex3.adiciona_aresta("a10", "G", "F")
        self.g_ex3.adiciona_aresta("a11", "H", "A")

        self.g_dj=MeuGrafo()
        self.g_dj.adiciona_vertice("A")
        self.g_dj.adiciona_vertice("B")
        self.g_dj.adiciona_vertice("C")
        self.g_dj.adiciona_vertice("D")
        self.g_dj.adiciona_vertice("E")
        self.g_dj.adiciona_vertice("F")
        self.g_dj.adiciona_vertice("G")
        self.g_dj.adiciona_vertice("H")
        self.g_dj.adiciona_aresta("a1","A","B",6)
        self.g_dj.adiciona_aresta("a2", "A", "C", 4)
        self.g_dj.adiciona_aresta("a3", "B", "D", 5)
        self.g_dj.adiciona_aresta("a4", "B", "H", 2)
        self.g_dj.adiciona_aresta("a5", "C", "B", 1)
        self.g_dj.adiciona_aresta("a6", "C", "D", 3)
        self.g_dj.adiciona_aresta("a7", "D", "E", 3)
        self.g_dj.adiciona_aresta("a8", "D", "F", 1)
        self.g_dj.adiciona_aresta("a9", "F", "G", 1)
        self.g_dj.adiciona_aresta("a10", "G", "E", 2)
        self.g_dj.adiciona_aresta("a11", "H", "G", 3)

        self.g_dj2 = MeuGrafo()
        self.g_dj2.adiciona_vertice("A")
        self.g_dj2.adiciona_vertice("B")
        self.g_dj2.adiciona_vertice("C")
        self.g_dj2.adiciona_vertice("D")
        self.g_dj2.adiciona_vertice("E")
        self.g_dj2.adiciona_vertice("F")
        self.g_dj2.adiciona_aresta("a1", "A", "B", 3)
        self.g_dj2.adiciona_aresta("a2", "A", "D", 2)
        self.g_dj2.adiciona_aresta("a3", "B", "C", 1)
        self.g_dj2.adiciona_aresta("a4", "C", "E", 1)
        self.g_dj2.adiciona_aresta("a5", "E", "F", 1)
        self.g_dj2.adiciona_aresta("a6", "D", "E", 4)
        self.g_dj2.adiciona_aresta("a7", "D", "F", 5)

        self.g_dj3 = MeuGrafo()
        self.g_dj3.adiciona_vertice("A")
        self.g_dj3.adiciona_vertice("B")
        self.g_dj3.adiciona_vertice("C")
        self.g_dj3.adiciona_vertice("D")
        self.g_dj3.adiciona_vertice("E")
        self.g_dj3.adiciona_vertice("F")
        self.g_dj3.adiciona_vertice("G")
        self.g_dj3.adiciona_aresta("a1", "A", "D", 2)
        self.g_dj3.adiciona_aresta("a2", "A", "B", 3)
        self.g_dj3.adiciona_aresta("a3", "B", "C", 1)
        self.g_dj3.adiciona_aresta("a4", "E", "D", 4)
        self.g_dj3.adiciona_aresta("a5", "F", "D", 5)
        self.g_dj3.adiciona_aresta("a6", "F", "E", 1)
        self.g_dj3.adiciona_aresta("a7", "E", "G", 2)
        self.g_dj3.adiciona_aresta("a8", "G", "F", 2)

        self.g_dj4 = MeuGrafo()
        self.g_dj4.adiciona_vertice("A")
        self.g_dj4.adiciona_vertice("B")
        self.g_dj4.adiciona_vertice("C")
        self.g_dj4.adiciona_vertice("D")
        self.g_dj4.adiciona_vertice("E")
        self.g_dj4.adiciona_vertice("F")
        self.g_dj4.adiciona_vertice("G")
        self.g_dj4.adiciona_aresta("a1", "A", "B", 1)
        self.g_dj4.adiciona_aresta("a2", "A", "C", 4)
        self.g_dj4.adiciona_aresta("a3", "B", "D", 5)
        self.g_dj4.adiciona_aresta("a4", "C", "D", 1)
        self.g_dj4.adiciona_aresta("a5", "C", "F", 3)
        self.g_dj4.adiciona_aresta("a6", "D", "E", 2)
        self.g_dj4.adiciona_aresta("a7", "D", "F", 1)
        self.g_dj4.adiciona_aresta("a8", "E", "G", 2)
        self.g_dj4.adiciona_aresta("a9", "F", "G", 4)

        self.g_bf = MeuGrafo()
        self.g_bf.adiciona_vertice("A")
        self.g_bf.adiciona_vertice("B")
        self.g_bf.adiciona_vertice("I")
        self.g_bf.adiciona_vertice("C")
        self.g_bf.adiciona_vertice("D")
        self.g_bf.adiciona_vertice("E")
        self.g_bf.adiciona_aresta("a1", "I", "A", 10)
        self.g_bf.adiciona_aresta("a2", "I", "E", 8)
        self.g_bf.adiciona_aresta("a3", "A", "C", 2)
        self.g_bf.adiciona_aresta("a4", "C", "B", -2)
        self.g_bf.adiciona_aresta("a5", "B", "A", 1)
        self.g_bf.adiciona_aresta("a6", "E", "D", 1)
        self.g_bf.adiciona_aresta("a7", "D", "A", -4)
        self.g_bf.adiciona_aresta("a8", "D", "C", -1)

        self.g_bf2 = MeuGrafo()
        self.g_bf2.adiciona_vertice("A")
        self.g_bf2.adiciona_vertice("B")
        self.g_bf2.adiciona_vertice("C")
        self.g_bf2.adiciona_vertice("D")
        self.g_bf2.adiciona_vertice("E")
        self.g_bf2.adiciona_vertice("F")
        self.g_bf2.adiciona_aresta("a1", "A", "B", 10)
        self.g_bf2.adiciona_aresta("a2", "A", "F", 8)
        self.g_bf2.adiciona_aresta("a3", "B", "E", 2)
        self.g_bf2.adiciona_aresta("a4", "E", "D", 2)
        self.g_bf2.adiciona_aresta("a5", "E", "C", -2)
        self.g_bf2.adiciona_aresta("a6", "D", "C", -3)
        self.g_bf2.adiciona_aresta("a7", "C", "B", 5)
        self.g_bf2.adiciona_aresta("a8", "D", "B", -4)
        self.g_bf2.adiciona_aresta("a9", "F", "D", 1)

        self.g_bagunca = MeuGrafo()
        self.g_bagunca.adiciona_vertice("A")
        self.g_bagunca.adiciona_vertice("B")
        self.g_bagunca.adiciona_vertice("C")
        self.g_bagunca.adiciona_vertice("D")
        self.g_bagunca.adiciona_vertice("E")
        self.g_bagunca.adiciona_aresta("a1", "A", "B", 21)
        self.g_bagunca.adiciona_aresta("a2", "B", "C", -5)
        self.g_bagunca.adiciona_aresta("a3", "B", "D", 1)
        self.g_bagunca.adiciona_aresta("a4", "B", "E", -10)
        self.g_bagunca.adiciona_aresta("a5", "D", "C", 9)
        self.g_bagunca.adiciona_aresta("a6", "E", "B", 5)
        self.g_bagunca.adiciona_aresta("a7", "E", "C", 12)

    def test_adiciona_aresta(self):
        self.assertTrue(self.g_p.adiciona_aresta('a10', 'J', 'C'))
        a = ArestaDirecionada("zxc", self.g_p.get_vertice("C"), self.g_p.get_vertice("Z"))
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
        self.assertTrue(self.g_p.remove_vertice("J"))
        with self.assertRaises(VerticeInvalidoError):
            self.g_p.remove_vertice("J")
        with self.assertRaises(VerticeInvalidoError):
            self.g_p.remove_vertice("K")
        self.assertTrue(self.g_p.remove_vertice("C"))
        self.assertTrue(self.g_p.remove_vertice("Z"))

    def test_remove_aresta(self):
        self.assertTrue(self.g_p.remove_aresta("a1"))
        self.assertFalse(self.g_p.remove_aresta("a1"))
        self.assertTrue(self.g_p.remove_aresta("a7"))
        self.assertFalse(self.g_c.remove_aresta("a"))
        self.assertTrue(self.g_c.remove_aresta("a6"))
        self.assertTrue(self.g_c.remove_aresta("a1", "J"))
        self.assertTrue(self.g_c.remove_aresta("a5", "C"))
        with self.assertRaises(VerticeInvalidoError):
            self.g_p.remove_aresta("a2", "X", "C")
        with self.assertRaises(VerticeInvalidoError):
            self.g_p.remove_aresta("a3", "X")
        with self.assertRaises(VerticeInvalidoError):
            self.g_p.remove_aresta("a3", v2="X")

    def test_eq(self):
        self.assertEqual(self.g_p, self.g_p2)
        self.assertNotEqual(self.g_p, self.g_p3)
        self.assertNotEqual(self.g_p, self.g_p_sem_paralelas)
        self.assertNotEqual(self.g_p, self.g_p4)

    def test_vertices_nao_adjacentes(self):
        self.assertEqual(set(self.g_p.vertices_nao_adjacentes()), {'J-E', 'J-P', 'J-M', 'J-T', 'J-Z', 'C-J', 'C-T', 'C-Z', 'C-M', 'C-P', 'E-C', 'E-J', 'E-P',
                                                                   'E-M', 'E-T', 'E-Z', 'P-J', 'P-E', 'P-M', 'P-T', 'P-Z', 'M-J', 'M-E', 'M-P', 'M-Z', 'T-J',
                                                                   'T-M', 'T-E', 'T-P', 'Z-J', 'Z-C', 'Z-E', 'Z-P', 'Z-M', 'Z-T'})


        self.assertEqual(set(self.g_c.vertices_nao_adjacentes()), {'C-J', 'E-C', 'P-C', 'E-J', 'P-E', 'P-J'})
        self.assertEqual(self.g_c3.vertices_nao_adjacentes(), [])
        self.assertEqual(set(self.g_e.vertices_nao_adjacentes()), {'A-D', 'A-E', 'B-A', 'B-C', 'B-D', 'B-E', 'C-E', 'D-C', 'D-A', 'E-D', 'E-C'})

    def test_ha_laco(self):
        self.assertFalse(self.g_p.ha_laco())
        self.assertFalse(self.g_p_sem_paralelas.ha_laco())
        self.assertFalse(self.g_c2.ha_laco())
        self.assertTrue(self.g_l1.ha_laco())
        self.assertTrue(self.g_l2.ha_laco())
        self.assertTrue(self.g_l3.ha_laco())
        self.assertTrue(self.g_l4.ha_laco())
        self.assertTrue(self.g_l5.ha_laco())
        self.assertTrue(self.g_e.ha_laco())

    def test_grau(self):
        # Paraíba
        self.assertEqual(self.g_p.grau_saida('J'), 1)
        self.assertEqual(self.g_p.grau_entrada('J'), 0)
        self.assertEqual(self.g_p.grau_saida('C'), 2)
        self.assertEqual(self.g_p.grau_entrada('C'), 5)
        self.assertEqual(self.g_p.grau_saida('E'), 0)
        self.assertEqual(self.g_p.grau_entrada('E'), 2)
        self.assertEqual(self.g_p.grau_saida('P'), 2)
        self.assertEqual(self.g_p.grau_entrada('P'), 0)
        self.assertEqual(self.g_p.grau_saida('M'), 2)
        self.assertEqual(self.g_p.grau_entrada('M'), 0)
        self.assertEqual(self.g_p.grau_saida('T'), 2)
        self.assertEqual(self.g_p.grau_entrada('T'), 1)
        self.assertEqual(self.g_p.grau_saida('Z'), 0)
        self.assertEqual(self.g_p.grau_entrada('Z'), 1)
        with self.assertRaises(VerticeInvalidoError):
            self.assertEqual(self.g_p.grau_saida('G'), 5)

        self.assertEqual(self.g_d.grau_entrada('A'), 0)
        self.assertEqual(self.g_d.grau_saida('A'), 1)
        self.assertEqual(self.g_d.grau_entrada('C'), 0)
        self.assertEqual(self.g_d.grau_saida('C'), 0)
        self.assertNotEqual(self.g_d.grau_entrada('D'), 2)
        self.assertNotEqual(self.g_d.grau_entrada('D'), 2)
        self.assertEqual(self.g_d2.grau_entrada('A'), 0)
        self.assertNotEqual(self.g_d.grau_saida('D'), 2)

        # Completos
        self.assertEqual(self.g_c.grau_entrada('J'), 0)
        self.assertEqual(self.g_c.grau_saida('J'), 3)
        self.assertEqual(self.g_c.grau_entrada('C'), 1)
        self.assertEqual(self.g_c.grau_saida('C'), 2)
        self.assertEqual(self.g_c.grau_saida('E'), 1)
        self.assertEqual(self.g_c.grau_entrada('E'), 2)
        self.assertEqual(self.g_c.grau_saida('P'), 0)
        self.assertEqual(self.g_c.grau_entrada('P'), 3)

        # Com laço.
        self.assertEqual(self.g_l1.grau_saida('A'), 2)
        self.assertEqual(self.g_l1.grau_entrada('A'), 3)
        self.assertEqual(self.g_l2.grau_entrada('B'), 2)
        self.assertEqual(self.g_l2.grau_saida('B'), 2)
        self.assertEqual(self.g_l4.grau_entrada('D'), 1)
        self.assertEqual(self.g_l4.grau_saida('D'), 1)

    def test_ha_paralelas(self):
        self.assertTrue(self.g_p.ha_paralelas())
        self.assertFalse(self.g_p_sem_paralelas.ha_paralelas())
        self.assertFalse(self.g_c.ha_paralelas())
        self.assertFalse(self.g_c2.ha_paralelas())
        self.assertFalse(self.g_c3.ha_paralelas())
        self.assertTrue(self.g_l1.ha_paralelas())
        self.assertTrue(self.g_e.ha_paralelas())

    def test_arestas_sobre_vertice(self):
        self.assertEqual(set(self.g_p.arestas_sobre_vertice('J')), {'a1'})
        self.assertEqual(set(self.g_p.arestas_sobre_vertice('C')), {'a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7'})
        self.assertEqual(set(self.g_p.arestas_sobre_vertice('M')), {'a7', 'a8'})
        self.assertEqual(set(self.g_l2.arestas_sobre_vertice('B')), {'a1', 'a2', 'a3'})
        self.assertEqual(set(self.g_d.arestas_sobre_vertice('C')), set())
        self.assertEqual(set(self.g_d.arestas_sobre_vertice('A')), {'asd'})
        with self.assertRaises(VerticeInvalidoError):
            self.g_p.arestas_sobre_vertice('A')
        self.assertEqual(set(self.g_e.arestas_sobre_vertice('D')), {'5', '6', '7', '8'})

    def test_warshall(self):
        resultado_g_ex = self.g_ex.warshall()
        esperado_g_ex = [
            [True, True, True, False, True],
            [False, False, False, False, False],
            [True, True, True, False, True],
            [True, True, True, False, True],
            [True, True, True, False, True]
        ]
        self.assertEqual(resultado_g_ex, esperado_g_ex)

        resultado_g_e = self.g_e.warshall()
        esperado_g_e = [
            [True, True, True, True, True],
            [False, False, False, False, False],
            [True, True, True, True, True],
            [True, True, True, True, True],
            [True, True, True, True, True]
        ]
        self.assertEqual(resultado_g_e, esperado_g_e)

        resultado_g_p = self.g_p.warshall()
        esperado_g_p = [[False, True, True, False, False, False, False],
                        [False, False, True, False, False, False, False],
                        [False, False, False, False, False, False, False],
                        [False, True, True, False, False, False, False], [False, True, True, False, False, True, True],
                        [False, True, True, False, False, False, True],
                        [False, False, False, False, False, False, False]]
        self.assertEqual(resultado_g_p, esperado_g_p)

        resultado_g_l3 = self.g_l3.warshall()
        esperado_g_l3 = [[False, False, False, False], [False, False, False, False], [True, False, True, False],
                         [False, False, False, True]]
        self.assertEqual(resultado_g_l3, esperado_g_l3)

        resultado_g_c = self.g_c.warshall()
        esperado_g_c = [[False, True, True, True], [False, False, True, True], [False, False, False, True],
                        [False, False, False, False]]
        self.assertEqual(resultado_g_c, esperado_g_c)

        resultado_g_ex2 = self.g_ex2.warshall()
        esperado_g_ex2 = [[False, False, False, False, False, True], [True, False, False, False, False, True],
                          [True, True, False, True, True, True], [True, True, False, True, True, True],
                          [True, True, False, True, True, True], [False, False, False, False, False, False]]
        self.assertEqual(resultado_g_ex2, esperado_g_ex2)

        resultado_g_ex3 = self.g_ex3.warshall()
        esperado_g_ex3 = [[True, True, True, True, True, True, False, True],
                          [True, True, True, True, True, True, False, True],
                          [True, True, True, True, True, True, False, True],
                          [True, True, True, True, True, True, False, True],
                          [True, True, True, True, True, True, False, True],
                          [True, True, True, True, True, True, False, True],
                          [True, True, True, True, True, True, False, True],
                          [True, True, True, True, True, True, False, True]]
        self.assertEqual(resultado_g_ex3, esperado_g_ex3)


    def test_dijkstra(self):
        resultado_ch = self.g_dj.Dijkstra('C', 'H')
        esperado_ch = ['C', 'a5', 'B', 'a4', 'H']
        self.assertEqual(resultado_ch, esperado_ch)

        resultado_ag = self.g_dj.Dijkstra('A', 'G')
        esperado_ag = ['A', 'a2', 'C', 'a6', 'D', 'a8', 'F', 'a9', 'G']
        self.assertEqual(resultado_ag, esperado_ag)

        resultado_ha = self.g_dj.Dijkstra('H', 'A')
        self.assertFalse(resultado_ha)


        resultado_af = self.g_dj2.Dijkstra('A', 'F')
        esperado_af = ['A', 'a1', 'B', 'a3', 'C', 'a4', 'E', 'a5', 'F']
        self.assertEqual(resultado_af, esperado_af)

        resultado_ed = self.g_dj2.Dijkstra('E', 'D')
        self.assertFalse(resultado_ed)

        resultado_cg = self.g_dj3.Dijkstra('C', 'G')
        self.assertFalse(resultado_cg)

        resultado_af4 = self.g_dj4.Dijkstra('A', 'F')
        esperado_af4 = ['A', 'a2', 'C', 'a4', 'D', 'a7', 'F']
        self.assertEqual(resultado_af4, esperado_af4)

        resultado_bg = self.g_dj4.Dijkstra('B', 'G')
        esperado_bg = ['B', 'a3', 'D', 'a6', 'E', 'a8', 'G']
        self.assertEqual(resultado_bg, esperado_bg)


    def test_bellman_ford(self):
        resultado_bi = self.g_bf.bellman_ford('B', 'I')
        self.assertFalse(resultado_bi)


        resultado_ib = self.g_bf.bellman_ford('I', 'B')
        esperado_ib = ['I', 'a2', 'E', 'a6', 'D', 'a7', 'A', 'a3', 'C', 'a4', 'B']
        self.assertEqual(resultado_ib, esperado_ib)

        resultado_fe = self.g_bf2.bellman_ford('F', 'E')
        esperado_fe = ['F', 'a9', 'D', 'a8', 'B', 'a3', 'E']
        self.assertEqual(resultado_fe, esperado_fe)

        resultado_ba = self.g_bf2.bellman_ford('B', 'A')
        self.assertFalse(resultado_ba)

        resultado_ab = self.g_bf2.bellman_ford('A', 'B')
        esperado_ab = ['A', 'a2', 'F', 'a9', 'D', 'a8', 'B']
        self.assertEqual(resultado_ab, esperado_ab)

        resultado_dc = self.g_bagunca.bellman_ford('D', 'C')
        esperado_dc = ['D', 'a5', 'C']
        self.assertEqual(resultado_dc, esperado_dc)

        resultado_ad = self.g_bagunca.bellman_ford('A', 'D')
        self.assertFalse(resultado_ad)
## O que são?

É a forma de descrever o grau do relacionamento entre duas entidades, ou seja, saber quantas vezes o relacionamento pode acontecer, existindo alguns possíveis: (0, 1), (0, n), (1, 1), (1, n) e (n, n).

### (0, 1)

- É o caso onde você tem no mínimo 0 ocorrências de uma instância e no máximo uma;
- Exemplo: Um aluno de uma graduação, tem no mínimo 0 diplomas da mesma e no máximo 1.

### (0, n)

- É o caso onde você tem no mínimo 0 ocorrências de uma instância e no máximo várias;
- Exemplo: Quantidade de produtos em um estoque, pode ter zero ou várias unidades de um produto.

###  (1, 1)

- É o caso onde você tem no mínimo 1 instância e no máximo 1 instância também;
- Exemplo: Um curso e seu coordenador, DEVE haver um e não pode haver mais de um.

### (1, n)

- É o caso onde você tem no mínimo 1 ocorrência de uma instância e no máximo várias também;
- Exemplo: Os produtos presentes em um nota fiscal, deve haver pelo menos um, mas podem haver vários também.

### (n, n)

- É o caso onde você tem no mínimo várias ocorrências de uma instância e no máximo várias também;
- Exemplo: Um curso bacharelado precisa ter no mínimo várias cadeiras e no máximo várias cadeiras também.


**A cardinalidade de uma relação é sempre descrita pela máxima que ela pode alcançar. Por exemplo: Cardinalidade de uma relação (1, 1) e (1, n) a cardinalidade da relação é 1 e n**


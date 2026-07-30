# Matriz de endpoints de Materiais para a versão 0.1.2

## Fonte e critério de seleção

Esta matriz foi conferida em 30 de julho de 2026 no OpenAPI publicado pela API
do CNBS. Foram observadas 32 operações `GET` sob `/material/v1`. A versão 0.1.2
preserva os sete endpoints anteriores e incorpora duas consultas de unidade de
fornecimento, mantendo o escopo restrito a Materiais e a operações de leitura.

## Endpoints incluídos

| Endpoint | Função pública | Caso de uso |
| --- | --- | --- |
| `GET /material/v1/palavra` | `get_busca_material_por_palavra()` | Pesquisa textual |
| `GET /material/v1/codigoPdmClasse` | `get_codigo_pdm_classe()` | Hierarquia por classe ou PDM |
| `GET /material/v1/dadosbasicospdmporcodigo` | `get_dados_basicos_pdm_por_codigo()` | Dados básicos e hierarquia do PDM |
| `GET /material/v1/dadosItemMaterialporCodigo` | `get_dados_item_material_por_codigo()` | Descrição do item por código |
| `GET /material/v1/dadosItemMaterialporCodigoSiasgnet` | `get_dados_item_material_por_codigo_siasgnet()` | Indicadores do item por código |
| `GET /material/v1/materialCaracteristcaValorporPDM` | `get_material_caracteristica_valor_por_pdm()` | Itens e características por PDM com filtro |
| `GET /material/v1/materialCaracteristicaValorPdmSemFiltro` | `get_material_caracteristica_valor_pdm_sem_filtro()` | Itens e características por PDM sem filtro |
| `GET /material/v1/unidadeFornecimentoPorCodigoItemMaterial` | `get_unidade_fornecimento_por_codigo_item_material()` | Unidades de fornecimento de um item |
| `GET /material/v1/existeunidadefornecimento` | `existe_unidade_fornecimento()` | Existência de uma unidade para um item |

## Endpoints `GET` pendentes até 0.2.0

| Endpoint | Situação na versão 0.1.2 |
| --- | --- |
| `GET /material/v1/caracteristicaPorCodigoPdm` | Adiado |
| `GET /material/v1/caracteristicaPorCodigoPdmSiglaAtiva` | Adiado |
| `GET /material/v1/classe` | Adiado |
| `GET /material/v1/classe/{codigo}` | Adiado |
| `GET /material/v1/classe/codigosDisponiveis/` | Adiado |
| `GET /material/v1/classificacaoContabilPorCodigoItemMaterial` | Adiado |
| `GET /material/v1/classificacaoContabilPorCodigoPdm` | Adiado |
| `GET /material/v1/dadosaliaspdmporcodigo` | Adiado |
| `GET /material/v1/dadoscaracteristicaparcialpdmporcodigo` | Adiado |
| `GET /material/v1/dadoscaracteristicapdmporcodigo` | Adiado |
| `GET /material/v1/dadositemmaterialcodigo` | Adiado |
| `GET /material/v1/dadosnaturezadespesapdmporcodigo` | Adiado |
| `GET /material/v1/dadosunidadefornecimentopdmporcodigo` | Adiado |
| `GET /material/v1/dadosunidademedidacaracteristicapdmporcodigo` | Adiado |
| `GET /material/v1/dadosvalorcaracteristicapdmporcodigo` | Adiado |
| `GET /material/v1/grupo` | Adiado |
| `GET /material/v1/grupo/{codigo}` | Adiado |
| `GET /material/v1/grupo/codigosDisponiveis` | Adiado |
| `GET /material/v1/itemPorCodigoMaterial` | Adiado |
| `GET /material/v1/pdmPorCodigoPostgre` | Adiado |
| `GET /material/v1/recuperaDadosItemMaterialPorCodigo` | Adiado |
| `GET /material/v1/situacaoitemmaterial` | Adiado |
| `GET /material/v1/unidadeFornecimentoPorCodigoPdm` | Adiado |

Cada lote futuro terá issue e versão próprias. A versão 0.2.0 depende da
incorporação, documentação e cobertura de testes dos 32 endpoints `GET`
inventariados. Operações `POST` e `PUT` continuam fora do escopo de leitura.

## Referências

- [Swagger da API CNBS](https://cnbs.estaleiro.serpro.gov.br/cnbs-api/swagger-ui/index.html#/)
- [Matriz da versão 0.1.1](matriz-material-0.1.1.md)
- [Decisão 0004 — Interface de unidades de fornecimento](../decisions/0004-interface-unidades-fornecimento-0.1.2.md)
- [Issue #17 — Roadmap até 0.2.0](https://github.com/rdurl0/cnbsr/issues/17)

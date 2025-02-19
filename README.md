# API de Laudos

Este repositório documenta a API para gerenciamento de laudos médicos. A API suporta criação, recuperação e busca de laudos.

## Endpoints

### **Criar um Laudo**

**POST /laudos**

Aceita uma requisição no formato **form-data** com os seguintes parâmetros:

- **`data`** *(obrigatório)* - string no formato `AAAA-MM-DD` (ano, mês, dia);
- **`crm`** *(obrigatório)* - string com o CRM do médico que laudou;
- **`texto`** *(obrigatório)* - texto do laudo sem formatação;
- **`arquivo`** *(obrigatório)* - arquivo PDF assinado digitalmente.

#### **Regras da API:**

1. Para requisições válidas, retorna **status code ****`201 - Created`**;
2. O header da resposta deve incluir `Location: /laudos/[:id]`, onde `[:id]` é um **UUID** do laudo criado;
3. O corpo da resposta é livre, podendo conter informações adicionais;
4. O arquivo PDF deve ser codificado e salvo em **Base64**.

---

### **Recuperar um Laudo por ID**

**GET /laudos/[****:id****]**

- Retorna os detalhes de um laudo caso ele exista;
- O parâmetro `[:id]` deve ser do tipo **UUID**;
- Se o laudo existir, retorna **status code ****`200 - OK`**;
- Se o laudo não existir, retorna **status code ****`404 - Not Found`**.

---

### **Buscar Laudos**

**GET /laudos?t=[****:termo**** da busca]**

- A busca é realizada no campo **texto** dos laudos;
- Se o parâmetro `t` não for informado, retorna **status code ****`400 - Bad Request`**;
- Retorna no máximo **50 registros** para otimizar a resposta;
- Mesmo se a busca não encontrar resultados, o status da resposta será **`200 - OK`**.

**GET /laudos/[:id]**

1. Deverá retornar os detalhes de um laudo caso este tenha sido criado anteriormente. O parâmetro [:id] deve ser do tipo UUID na versão que escolher;
2. O status code para laudos que existem deve ser 200 - OK;
3. Para recursos que não existem, deve-se retornar 404 - Not Found.

---

### **Entrega**

Sua aplicação será entregue em contêineres com `docker compose` através da `porta 9999`.

### **Testes**

Os testes serão realizados a partir do Docker entregue, tanto via `Postman`, para os end-points, quanto para a `página web` de consulta.

As funcionalidades serão avaliadas de acordo com o descrito acima.

`Não verificaremos requisitos não-funcionais`, como performance, usabilidade, segurança e etc.

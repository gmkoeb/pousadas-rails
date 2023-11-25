# README
# Pousadas Rails

## Tabela de Conteúdos
- [Instalação e Execução](#instalação-e-execução)
- [Pré Requisitos](#pré-requisitos)
- [API](#api) 
## Instalação e Execução
Para executar a aplicação você deve:
1. Clone o repositório

2. No diretório: 

        cd pousadas-rails

3. Instale as dependências do projeto:

        bundle install

4. Realize as migrations pendentes:
   
        rails db:migrate
   
5. Inicie o servidor de desenvolvimento:

        rails s

6. Agora o projeto deve estar instalado e funcionando em http://localhost:3000.
## Pré Requisitos
Antes de começar, certifique-se que você têm as seguintes dependências:
- Ruby (versão 3.2.2)
- Rails (versão 7.0.8)
- SQLite
## API
### URL Base
A URL base para todos os endpoints da API é http://localhost:3000/api/v1/
### Endpoints
### 1. Lista de pousadas
GET /inns:

```json
[
   {
      "id":1,
      "corporate_name":"Exemplo LTDA",
      "brand_name":"Pousada Exemplo",
      "registration_number":"444",
      "phone":"4444444",
      "email":"exemplo@email.com",
      "address":"exemplo",
      "district":"exemplo",
      "state":"exemplo",
      "city":"exemplo",
      "zip_code":"555555",
      "description":"55555",
      "payment_methods":"[\"Dinheiro\", \"PIX\", \"Cartão de crédito\", \"Cartão de débito\"]",
      "accepts_pets":true,
      "terms_of_service":"exemplo",
      "check_in_check_out_time":"2000-01-01T15:00:00.000-02:00",
      "created_at":"2023-11-23T15:48:21.020-03:00",
      "updated_at":"2023-11-23T15:48:53.779-03:00",
      "slug":"exemplo-exemplo",
      "user_id":1,
      "status":"published"
   }
]
```
Pode-se também filtrar resultados pelo nome fantasia (brand_name), da seguinte forma:

GET /inns?query=brand_name 

Exemplo:

GET /inns?query=pousada exemplo

```json
[
   {
      "id":1,
      "corporate_name":"Exemplo LTDA",
      "brand_name":"Pousada Exemplo",
      "registration_number":"444",
      "phone":"4444444",
      "email":"exemplo@email.com",
      "address":"exemplo",
      "district":"exemplo",
      "state":"exemplo",
      "city":"exemplo",
      "zip_code":"555555",
      "description":"55555",
      "payment_methods":"[\"Dinheiro\", \"PIX\", \"Cartão de crédito\", \"Cartão de débito\"]",
      "accepts_pets":true,
      "terms_of_service":"exemplo",
      "check_in_check_out_time":"2000-01-01T15:00:00.000-02:00",
      "created_at":"2023-11-23T15:48:21.020-03:00",
      "updated_at":"2023-11-23T15:48:53.779-03:00",
      "slug":"exemplo-exemplo",
      "user_id":1,
      "status":"published"
   }
]
```
### 2. Detalhes de uma pousada específica
GET /inns/:id 

Parâmetros: `:id`. ID da pousada da qual deseja ver os detalhes. Por exemplo:

GET /inns/1

```json
{
  "id":1,
  "brand_name":"Pousada Exemplo",
  "phone":"4444444",
  "email":"exemplo@email.com",
  "address":"exemplo",
  "district":"exemplo",
  "state":"exemplo",
  "city":"exemplo",
  "zip_code":"555555",
  "description":"55555",
  "payment_methods":"[\"Dinheiro\", \"PIX\", \"Cartão de crédito\", \"Cartão de débito\"]",
  "accepts_pets":true,
  "terms_of_service":"exemplo",
  "check_in_check_out_time":"2000-01-01T15:00:00.000-02:00",
  "formatted_time":"15:00",
  "created_at":"2023-11-23T15:48:21.020-03:00",
  "updated_at":"2023-11-23T15:48:53.779-03:00",
  "slug":"exemplo-exemplo",
  "user_id":1,
  "status":"published"
}
```
### 3. Quartos de uma pousada
GET /inns/:inn_id/rooms

Parâmetros: `:inn_id`. ID da pousada da qual deseja obter os quartos

GET /inns/1/rooms

```json
[
   {
      "id":1,
      "name":"Quarto de Exemplo",
      "description":"Exemplo de listagem de quartos da api",
      "area":5,
      "maximum_guests":10,
      "price":200,
      "has_bathroom":true,
      "has_balcony":true,
      "has_air_conditioner":true,
      "has_tv":true,
      "has_wardrobe":true,
      "has_coffer":true,
      "accessible":true,
      "created_at":"2023-11-23T15:48:45.729-03:00",
      "updated_at":"2023-11-23T15:48:51.236-03:00",
      "inn_id":1,
      "slug":"quarto-de-exemplo",
      "status":"published"
   }
]
```
### 4. Checagem de disponibilidade de quarto
POST /rooms/:room_id/check

### Parâmetros da requisição
Essa requisição espera os seguintes parâmetros:

reservation_details (Object)

check_in (Date): Data de check-in para a reserva.

check_out (Date): Data de check-out para a reserva.

guests (Integer): Número de hóspedes da reserva.

Exemplo:
```json
{
  "reservation_details": {
    "check_in": "2023-12-01",
    "check_out": "2023-12-03",
    "guests": 3
  }
}
```
### Resposta
Se os parâmetros da requisição forem válidos e compatíveis com o quarto desejado, o cliente obtêm como resposta o valor total da reserva:

```json
{
  "total_price": 2000,
  "room": 1
}
```
Se os parâmetros da requisição forem inválidos, o cliente obtêm como resposta mensagens de erro:

```json
{
  "errors":["Quantidade de Hóspedes acima do suportado pelo quarto", "Data de Entrada precisa ser anterior à Data de Saída"]
}

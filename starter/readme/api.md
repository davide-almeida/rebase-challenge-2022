# Rebase Challenge 2022

Ruby API for listing medical exams from a CSV file.
The challenge description can be read [here](insctructions.md).
And you can go back to the Readme [here](../../README.md).

## API Documentation - Examples

---

## GET /tests

---

### Request:
```bash
GET /tests
```

Response (status: 200):

```json
[
  {
    "result_token": "GOQF7S",
    "result_date": "2021-05-04",
    "cpf": "081.878.172-67",
    "name": "Emanuel Beltrão Neto",
    "email": "jennine@mosciski-swaniawski.co",
    "birthday": "1989-10-28",
    "doctor": {
      "crm": "B0000DHDOF",
      "crm_state": "MT",
      "name": "Luiz Felipe Raia Jr."
    },
    "tests": [
      {
        "test_type": "hemácias",
        "test_limits": "45-52",
        "result": "71"
      },
      {
        "test_type": "leucócitos",
        "test_limits": "9-61",
        "result": "87"
      },
      {
        "test_type": "plaquetas",
        "test_limits": "11-93",
        "result": "21"
      },
      {
        "test_type": "hdl",
        "test_limits": "19-75",
        "result": "97"
      }
    ]
  },
  {
    "result_token": "QDU4KD",
    "result_date": "2022-01-31",
    "cpf": "071.488.453-78",
    "name": "Antônio Rebouças",
    "email": "adalberto_grady@feil.org",
    "birthday": "1999-04-11",
    "doctor": {
      "crm": "B0000DHDOF",
      "crm_state": "MT",
      "name": "Luiz Felipe Raia Jr."
    },
    "tests": [
      {
        "test_type": "hemácias",
        "test_limits": "45-52",
        "result": "30"
      },
      {
        "test_type": "leucócitos",
        "test_limits": "9-61",
        "result": "40"
      },
      {
        "test_type": "plaquetas",
        "test_limits": "11-93",
        "result": "78"
      },
      {
        "test_type": "hdl",
        "test_limits": "19-75",
        "result": "22"
      }
    ]
  }
]
```

### Request:
```bash
GET /tests
```

Response (status: 404):

```json
{
  "message": "Não há testes cadastrados."
}
```

---

## GET /tests/:token

---


Request:
```bash
GET /tests/IQCZ17
```

Response (status: 200):

```json
{
  "result_token": "IQCZ17",
  "result_date": "2021-08-05",
  "cpf": "048.973.170-88",
  "name": "Emilly Batista Neto",
  "email": "gerald.crona@ebert-quigley.com",
  "birthday": "2001-03-11",
  "doctor": {
    "crm": "B000BJ20J4",
    "crm_state": "PI",
    "name": "Maria Luiza Pires"
  },
  "tests": [
    {
      "test_type": "hemácias",
      "test_limits": "45-52",
      "result": "97"
    },
    {
      "test_type": "leucócitos",
      "test_limits": "9-61",
      "result": "89"
    },
    {
      "test_type": "plaquetas",
      "test_limits": "11-93",
      "result": "97"
    },
    {
      "test_type": "hdl",
      "test_limits": "19-75",
      "result": "0"
    }
  ]
}
```

Request:
```bash
GET /tests/xxxxxxxxx
```

Response (status: 404):

```json
{
  "message": "Este token é inválido."
}
```

---

## POST /import

---

Request:
```bash
POST /import
```

Response (status: 200):

```json
{
  "message": "O cadastro está sendo processado!"
}
```

Example post with Postman:

<p align="center">
  <img src="https://user-images.githubusercontent.com/85287720/179868801-a6fb2961-a867-444e-997c-39b36dafbdcf.png" alt="Example with Postman"/>
</p>

Request:
```bash
POST /import
```

Response:

```json
{
  "message": "Erro ao tentar cadastrar o arquivo .CSV!"
}
```

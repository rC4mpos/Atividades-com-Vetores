# gerenciadorcaixas_app

Camada de view em Flutter para o backend `gerenciadorcaixas` (Spring Boot + Kotlin).
Faz o CRUD de **Caixa d'água** consumindo o endpoint `/caixas-dagua`.

## Estrutura

```
lib/
├── main.dart                          # MaterialApp
├── models/caixa_dagua.dart            # CaixaDAgua + enums Cor e MaterialCaixa
├── services/caixa_dagua_service.dart  # chamadas HTTP (GET, POST, PUT, DELETE)
└── views/
    ├── caixa_dagua_list_page.dart     # lista, exclusão e atalho para edição
    └── caixa_dagua_form_page.dart     # formulário de cadastro/edição
```

## Endpoints usados

| Método | Rota                  | Ação                |
|--------|-----------------------|---------------------|
| GET    | `/caixas-dagua`       | listar              |
| POST   | `/caixas-dagua`       | cadastrar           |
| PUT    | `/caixas-dagua/{id}`  | atualizar           |
| DELETE | `/caixas-dagua/{id}`  | excluir             |

## Como rodar

1. Suba o backend (`gerenciadorcaixas`) na porta 8080 com o PostgreSQL ativo.
2. Na primeira vez, gere as pastas das plataformas e baixe as dependências:

   ```bash
   cd gerenciadorcaixas_app
   flutter create . --project-name gerenciadorcaixas_app
   flutter pub get
   ```

3. Rode o app:

   ```bash
   # Navegador (usa http://localhost:8080)
   flutter run -d chrome

   # Emulador Android (o localhost do PC é 10.0.2.2 dentro do emulador)
   flutter run --dart-define=API_URL=http://10.0.2.2:8080
   ```

> No Android, se usar `http` (sem TLS), pode ser preciso adicionar
> `android:usesCleartextTraffic="true"` na tag `<application>` do
> `android/app/src/main/AndroidManifest.xml`.

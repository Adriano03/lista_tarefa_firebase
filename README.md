# lista_tarefas_firebase

Projeto Flutter - Lista de Tarefas com Firebase

## Getting Started

Aplicativo desenvolvido para registrar qualquer tipo de tarefa, podendo adicionar título e descrição, editar, excluir temporiamente e permanentemente, as tarefas por padrão ficam pendentes depois de criadas, podendo marcar como concluído e também adicionar aos favoritos. 
Todas as tarefas são referentes a apenas o usuário logado no firebase. O usuário pode criar e logar com uma conta, em também pode recuperar a senha.
Para gerência de estado é utilizado o bloc e para salvar os dados é utilizado o firebase.

- Tela de cadastro e login para o usuário se conectar com o Firebase;
- Tela para recuperação de senha;
- Utilização do pacote getStorage para manter o uid do usuário, assim não precisar logar toda vez que entrar no app;
- Todas as tarefas adicionadas ao firebase para o email do usuário;
- Adicionar tarefas através de uma modal contendo o título e descrição;
- Para atualizar e renderizar os itens da tela é utilizado o BlocBuilder;
- MultiBlocProvider para fornecer dados para os widgets filhos;
- As tarefas adicionadas são exibidas em um List.builder;
- Validação no formulário para não adicionar tarefas com texto em branco;
- Existem 4 tipos de identificação para as tarefas. Elas são: Tarefas pendentes, tarefas concluídas, tarefas favoritas, e tarefas removidas;
- Cada tarefa da lista contém um PopupMenu podendo editar, excluir e adicionar ou remover dos favoritos;
- Na lixeira ao abrir o popupMenu e clicar em excluir, o item é excluído permanente. Pode também excluir toda a lista clicando no botão na appBar;
- Lógica desenvolvida para poder adicionar, excluir, editar, ou adicionar ou retirar dos favoritos em qualquer tela;
- Os items da lixeira podem ser restaurados;
- Opção para mudar o aplicativo inteiro para modo noturno;


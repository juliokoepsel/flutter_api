<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id_livro = isset($_POST['id_livro']) ? $_POST['id_livro'] : '';
    $acao = isset($_POST['acao']) ? $_POST['acao'] : '';
    $titulo = isset($_POST['titulo']) ? $_POST['titulo'] : '';
    $data_hora = isset($_POST['data_hora']) ? $_POST['data_hora'] : '';

    $data = array(
        'id_livro' => $id_livro,
        'acao' => $acao,
        'titulo' => $titulo,
        'data_hora' => date("Y-m-d H:i:s"),
    );

    $filePath = 'logs.txt';

    if ($file = fopen($filePath, 'a')) {
        fseek($file, 0, SEEK_END);

        if (ftell($file) > 0) {
            fwrite($file, ',');
        }

        fwrite($file, json_encode($data, JSON_UNESCAPED_UNICODE));
        fclose($file);

        echo 'Dados armazenados com sucesso';
    } else {
        echo 'Erro ao abrir o arquivo';
    }
} else {
    echo 'Método de requisição inválida';
}
?>

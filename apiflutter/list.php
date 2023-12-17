<?php
$filePath = 'logs.txt';
if (file_exists($filePath)) {
    $fileContents = file_get_contents($filePath);
    if (!empty($fileContents)) {
        $decodedData = json_decode(('['.$fileContents.']'), true);
        if ($decodedData !== null) {

            echo json_encode(array_reverse($decodedData));

        } else {
            echo 'Erro ao decodificar dados JSON';
        }
    } else {
        echo 'Arquivo vazio';
    }
} else {
    echo 'Arquivo não encontrado';
}
?>

-- Criar banco de dados e usar
CREATE DATABASE IF NOT EXISTS Facul;
USE Facul;

-- Tabela de Áreas
CREATE TABLE IF NOT EXISTS Areas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

-- Tabela de Cursos
CREATE TABLE IF NOT EXISTS Cursos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    area_id INT,
    FOREIGN KEY (area_id) REFERENCES Areas(id)
);

-- Tabela de Alunos
CREATE TABLE IF NOT EXISTS Alunos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    sobrenome VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

-- Tabela de Matrículas
CREATE TABLE IF NOT EXISTS Matriculas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    aluno_id INT,
    curso_id INT,
    data_matricula DATE NOT NULL,
    FOREIGN KEY (aluno_id) REFERENCES Alunos(id),
    FOREIGN KEY (curso_id) REFERENCES Cursos(id),
    UNIQUE (aluno_id, curso_id)
);

-- Funções
DELIMITER //

CREATE FUNCTION ObterAreaId (nome_area VARCHAR(100))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE area_id INT;
    SELECT id INTO area_id FROM Areas WHERE nome = nome_area LIMIT 1;
    RETURN area_id;
END //

CREATE FUNCTION ObterCursoId (curso_nome VARCHAR(100), area_nome VARCHAR(100))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE curso_id INT;
    SELECT Cursos.id INTO curso_id
    FROM Cursos
    JOIN Areas ON Cursos.area_id = Areas.id
    WHERE Cursos.nome = curso_nome AND Areas.nome = area_nome
    LIMIT 1;
    RETURN curso_id;
END //

-- Procedimentos
CREATE PROCEDURE InserirCurso (
    IN nome_curso VARCHAR(100),
    IN nome_area VARCHAR(100)
)
BEGIN
    DECLARE area_id INT;
    
    -- Verifica se a área já existe
    SET area_id = ObterAreaId(nome_area);
    
    -- Se a área não existir, insere a nova área
    IF area_id IS NULL THEN
        INSERT INTO Areas (nome) VALUES (nome_area);
        SET area_id = LAST_INSERT_ID();
    END IF;
    
    -- Insere o curso
    INSERT INTO Cursos (nome, area_id) VALUES (nome_curso, area_id);
END //

CREATE PROCEDURE MatricularAluno (
    IN nome_aluno VARCHAR(100),
    IN sobrenome_aluno VARCHAR(100),
    IN nome_curso VARCHAR(100),
    IN nome_area VARCHAR(100)
)
BEGIN
    DECLARE aluno_id INT;
    DECLARE curso_id INT;
    DECLARE email VARCHAR(255);
    
    -- Gera o email
    SET email = CONCAT(nome_aluno, '.', sobrenome_aluno, '@dominio.com');
    
    -- Insere o aluno, se não existir
    INSERT INTO Alunos (nome, sobrenome, email) 
    VALUES (nome_aluno, sobrenome_aluno, email)
    ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id);
    
    SET aluno_id = LAST_INSERT_ID();
    
    -- Obtém o ID do curso
    SET curso_id = ObterCursoId(nome_curso, nome_area);
    
    -- Tenta inserir a matrícula
    INSERT INTO Matriculas (aluno_id, curso_id, data_matricula)
    VALUES (aluno_id, curso_id, CURDATE())
    ON DUPLICATE KEY UPDATE id = id;
END //

CREATE PROCEDURE InserirAlunos()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 200 DO
        CALL MatricularAluno(
            CONCAT('Aluno', i), 
            CONCAT('Sobrenome', i), 
            'Computação', 
            'Tecnologia'
        );
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;

INSERT INTO Areas (nome) VALUES 
('Engenharia'), 
('Ciências Humanas'), 
('Saúde'), 
('Tecnologia'), 
('Artes');

CALL InserirCurso('Engenharia Civil', 'Engenharia');
CALL InserirCurso('Engenharia Elétrica', 'Engenharia');
CALL InserirCurso('Engenharia Mecânica', 'Engenharia');
CALL InserirCurso('Engenharia de Produção', 'Engenharia');
CALL InserirCurso('Engenharia Química', 'Engenharia');
CALL InserirCurso('Psicologia', 'Ciências Humanas');
CALL InserirCurso('História', 'Ciências Humanas');
CALL InserirCurso('Filosofia', 'Ciências Humanas');
CALL InserirCurso('Sociologia', 'Ciências Humanas');
CALL InserirCurso('Pedagogia', 'Ciências Humanas');
CALL InserirCurso('Medicina', 'Saúde');
CALL InserirCurso('Enfermagem', 'Saúde');
CALL InserirCurso('Odontologia', 'Saúde');
CALL InserirCurso('Farmácia', 'Saúde');
CALL InserirCurso('Fisioterapia', 'Saúde');
CALL InserirCurso('Computação', 'Tecnologia');
CALL InserirCurso('Análise de Sistemas', 'Tecnologia');
CALL InserirCurso('Engenharia de Software', 'Tecnologia');
CALL InserirCurso('Ciência da Computação', 'Tecnologia');
CALL InserirCurso('Redes de Computadores', 'Tecnologia');
CALL InserirCurso('Desenho Industrial', 'Artes');
CALL InserirCurso('Música', 'Artes');
CALL InserirCurso('Artes Cênicas', 'Artes');
CALL InserirCurso('Cinema', 'Artes');
CALL InserirCurso('Design Gráfico', 'Artes');

CALL MatricularAluno('João', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Maria', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Pedro', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Ana', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Lucas', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Beatriz', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Guilherme', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Camila', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Rafael', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Larissa', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('André', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Juliana', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Gabriel', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Isabela', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Leonardo', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Luana', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Bruno', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Letícia', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Matheus', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Laura', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Lucas', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Carolina', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Gustavo', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Vanessa', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Thiago', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Amanda', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Diego', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Fernanda', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Marcelo', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Bruna', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Eduardo', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Jessica', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Felipe', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Tatiane', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Ricardo', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Michele', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Caio', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Débora', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Alexandre', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Jaqueline', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('André', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Aline', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Gabriel', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Priscila', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Bruno', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Nathalia', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Lucas', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Marina', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Mateus', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Juliana', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Carlos', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Mariana', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Gustavo', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Barbara', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Rafael', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Renata', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Beatriz', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Thiago', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Amanda', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Daniel', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Luana', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Douglas', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Caroline', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Vinícius', 'Souza','Computação', 'Tecnologia');
CALL MatricularAluno('Isabela', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Lucas', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Bianca', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Eduardo', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Letícia', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Felipe', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Caio', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Larissa', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Alexandre', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Jessica', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Lucas', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Rodrigo', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Carolina', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Vinícius', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Isabela', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Lucas', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Lucas', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Bianca', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Douglas', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Caroline', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Vinícius', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Eduardo', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Letícia', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Felipe', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Caio', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Larissa', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Alexandre', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Jessica', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Lucas', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Rodrigo', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Carolina', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Vinícius', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Isabela', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Lucas', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Bianca', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Douglas', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Caroline', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Vinícius', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Eduardo', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Letícia', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Felipe', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Caio', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Larissa', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Alexandre', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Jessica', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Lucas', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Rodrigo', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Carolina', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Vinícius', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Isabela', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Lucas', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Lucas', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Bianca', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Douglas', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Caroline', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Vinícius', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Eduardo', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Letícia', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Felipe', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Caio', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Larissa', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Alexandre', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Jessica', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Lucas', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Rodrigo', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Carolina', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Vinícius', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Isabela', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Lucas', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Bianca', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Douglas', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Caroline', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Vinícius', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Eduardo', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Letícia', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Felipe', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Caio', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Larissa', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Alexandre', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Jessica', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Lucas', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Rodrigo', 'Silva', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Carolina', 'Fernandes', 'Psicologia', 'Ciências Humanas');
CALL MatricularAluno('Vinícius', 'Almeida', 'Medicina', 'Saúde');
CALL MatricularAluno('Isabela', 'Souza', 'Computação', 'Tecnologia');
CALL MatricularAluno('Lucas', 'Pereira', 'Desenho Industrial', 'Artes');
CALL MatricularAluno('Bruno', 'Mendes', 'Engenharia Mecânica', 'Engenharia');
CALL MatricularAluno('Mariana', 'Rodrigues', 'História', 'Ciências Humanas');
CALL MatricularAluno('Gustavo', 'Ferreira', 'Enfermagem', 'Saúde');
CALL MatricularAluno('Carla', 'Ribeiro', 'Análise de Sistemas', 'Tecnologia');
CALL MatricularAluno('Fernando', 'Oliveira', 'Arquitetura', 'Artes');
CALL MatricularAluno('Patrícia', 'Santos', 'Engenharia Civil', 'Engenharia');
CALL MatricularAluno('Leonardo', 'Albuquerque', 'Pedagogia', 'Ciências Humanas');
CALL MatricularAluno('Juliana', 'Gomes', 'Medicina', 'Saúde');
CALL MatricularAluno('Renato', 'Pinto', 'Ciência da Computação', 'Tecnologia');
CALL MatricularAluno('Luciana', 'Silveira', 'Design Gráfico', 'Artes');
CALL MatricularAluno('Rafael', 'Costa', 'Engenharia Elétrica', 'Engenharia');
CALL MatricularAluno('Amanda', 'Martins', 'Filosofia', 'Ciências Humanas');
CALL MatricularAluno('Rodrigo', 'Oliveira', 'Nutrição', 'Saúde');
CALL MatricularAluno('Bianca', 'Barbosa', 'Sistemas de Informação', 'Tecnologia');
CALL MatricularAluno('Diego', 'Nunes', 'Belas Artes', 'Artes');
CALL MatricularAluno('Tatiane', 'Lima', 'Engenharia de Produção', 'Engenharia');
CALL MatricularAluno('Lucas', 'Dias', 'Letras', 'Ciências Humanas');
CALL MatricularAluno('Vanessa', 'Rocha', 'Fisioterapia', 'Saúde');
CALL MatricularAluno('Felipe', 'Machado', 'Engenharia de Software', 'Tecnologia');
CALL MatricularAluno('Camila', 'Mendes', 'Teatro', 'Artes');
CALL MatricularAluno('Anderson', 'Santana', 'Engenharia Química', 'Engenharia');
CALL MatricularAluno('Aline', 'Oliveira', 'Geografia', 'Ciências Humanas');
CALL MatricularAluno('Marcelo', 'Costa', 'Biomedicina', 'Saúde');
CALL MatricularAluno('Larissa', 'Pereira', 'Redes de Computadores', 'Tecnologia');
CALL MatricularAluno('Bruno', 'Cavalcanti', 'Música', 'Artes');
CALL MatricularAluno('Fabiana', 'Carvalho', 'Engenharia Ambiental', 'Engenharia');
CALL MatricularAluno('Ricardo', 'Silva', 'Educação Física', 'Ciências Humanas');
CALL MatricularAluno('Carolina', 'Martins', 'Odontologia', 'Saúde');
CALL MatricularAluno('Vinícius', 'Alves', 'Engenharia de Telecomunicações', 'Tecnologia');
CALL MatricularAluno('Mariana', 'Ferreira', 'Dança', 'Artes');
CALL MatricularAluno('José', 'Rocha', 'Engenharia de Alimentos', 'Engenharia');
CALL MatricularAluno('Luana', 'Pereira', 'Psicopedagogia', 'Ciências Humanas');
CALL MatricularAluno('Pedro', 'Fernandes', 'Medicina Veterinária', 'Saúde');
CALL MatricularAluno('Priscila', 'Oliveira', 'Gestão da Tecnologia da Informação', 'Tecnologia');
CALL MatricularAluno('Paulo', 'Sousa', 'Cinema', 'Artes');
CALL MatricularAluno('Tatiana', 'Moraes', 'Engenharia Biomédica', 'Engenharia');
CALL MatricularAluno('Fernando', 'Carvalho', 'Jornalismo', 'Ciências Humanas');
CALL MatricularAluno('Ana', 'Rodrigues', 'Terapia Ocupacional', 'Saúde');
CALL MatricularAluno('Lucas', 'Santos', 'Animação Digital', 'Tecnologia');
CALL MatricularAluno('Cristina', 'Nogueira', 'Gastronomia', 'Artes');
CALL MatricularAluno('Marcos', 'Silva', 'Engenharia de Minas', 'Engenharia');
CALL MatricularAluno('Alessandra', 'Gonçalves', 'Sociologia', 'Ciências Humanas');
CALL MatricularAluno('André', 'Costa', 'Fonoaudiologia', 'Saúde');
CALL MatricularAluno('Laura', 'Lima', 'Ciências da Computação', 'Tecnologia');
CALL MatricularAluno('Raul', 'Oliveira', 'Moda', 'Artes');
CALL MatricularAluno('Jéssica', 'Dias', 'Engenharia de Petróleo', 'Engenharia');
CALL MatricularAluno('Rafael', 'Ferreira', 'Antropologia', 'Ciências Humanas');
CALL MatricularAluno('Fernanda', 'Pinto', 'Enfermagem', 'Saúde');
CALL MatricularAluno('Luciano', 'Souza', 'Engenharia de Controle e Automação', 'Tecnologia');
CALL MatricularAluno('Sabrina', 'Machado', 'Arquitetura e Urbanismo', 'Artes');
CALL MatricularAluno('Alex', 'Barbosa', 'Engenharia de Produção', 'Engenharia');
CALL MatricularAluno('Carla', 'Martins', 'Design Gráfico', 'Artes');
CALL MatricularAluno('Fernando', 'Rodrigues', 'Engenharia Elétrica', 'Engenharia');
CALL MatricularAluno('Patrícia', 'Almeida', 'História', 'Ciências Humanas');
CALL MatricularAluno('Leonardo', 'Silva', 'Nutrição', 'Saúde');
CALL MatricularAluno('Tatiane', 'Ferreira', 'Engenharia de Controle e Automação', 'Tecnologia');
CALL MatricularAluno('Ricardo', 'Mendes', 'Arquitetura e Urbanismo', 'Artes');
CALL MatricularAluno('Mariana', 'Santos', 'Engenharia Química', 'Engenharia');
CALL MatricularAluno('João', 'Silva', 'Sociologia', 'Ciências Humanas');
CALL MatricularAluno('Patrícia', 'Oliveira', 'Medicina Veterinária', 'Saúde');
CALL MatricularAluno('Luiz', 'Martins', 'Gestão da Tecnologia da Informação', 'Tecnologia');
CALL MatricularAluno('Amanda', 'Pereira', 'Cinema', 'Artes');
CALL MatricularAluno('Rodrigo', 'Santos', 'Engenharia Biomédica', 'Engenharia');
CALL MatricularAluno('Fernanda', 'Gonçalves', 'Jornalismo', 'Ciências Humanas');
CALL MatricularAluno('Roberto', 'Almeida', 'Terapia Ocupacional', 'Saúde');
CALL MatricularAluno('Camila', 'Rocha', 'Animação Digital', 'Tecnologia');
CALL MatricularAluno('Gustavo', 'Silva', 'Gastronomia', 'Artes');
CALL MatricularAluno('Bianca', 'Fernandes', 'Engenharia de Minas', 'Engenharia');
CALL MatricularAluno('Lucas', 'Mendes', 'Letras', 'Ciências Humanas');
CALL MatricularAluno('Ana', 'Costa', 'Fonoaudiologia', 'Saúde');
CALL MatricularAluno('Vinícius', 'Martins', 'Arquitetura e Urbanismo', 'Artes');
CALL MatricularAluno('Tatiane', 'Silva', 'Engenharia de Produção', 'Engenharia');
CALL MatricularAluno('Fernando', 'Ferreira', 'Teatro', 'Ciências Humanas');
CALL MatricularAluno('Luciana', 'Oliveira', 'Fisioterapia', 'Saúde');
CALL MatricularAluno('Ricardo', 'Santos', 'Gestão da Tecnologia da Informação', 'Tecnologia');
CALL MatricularAluno('André', 'Silveira', 'Música', 'Artes');
CALL MatricularAluno('Amanda', 'Fernandes', 'Engenharia Ambiental', 'Engenharia');
CALL MatricularAluno('Bruno', 'Rocha', 'Filosofia', 'Ciências Humanas');
CALL MatricularAluno('Mariana', 'Almeida', 'Fonoaudiologia', 'Saúde');
CALL MatricularAluno('Gustavo', 'Pereira', 'Ciência da Computação', 'Tecnologia');
CALL MatricularAluno('João', 'Silva', 'Sociologia', 'Ciências Humanas');
CALL MatricularAluno('Patrícia', 'Oliveira', 'Medicina Veterinária', 'Saúde');
CALL MatricularAluno('Luiz', 'Martins', 'Gestão da Tecnologia da Informação', 'Tecnologia');
CALL MatricularAluno('Amanda', 'Pereira', 'Cinema', 'Artes');
CALL MatricularAluno('Rodrigo', 'Santos', 'Engenharia Biomédica', 'Engenharia');
CALL MatricularAluno('Fernanda', 'Gonçalves', 'Jornalismo', 'Ciências Humanas');
CALL MatricularAluno('Roberto', 'Almeida', 'Terapia Ocupacional', 'Saúde');
CALL MatricularAluno('Ricardo', 'Santos', 'Gestão da Tecnologia da Informação', 'Tecnologia');
CALL MatricularAluno('André', 'Silveira', 'Música', 'Artes');
CALL MatricularAluno('Amanda', 'Fernandes', 'Engenharia Ambiental', 'Engenharia');
CALL MatricularAluno('Rafaela', 'Rodrigues', 'Moda', 'Artes');
CALL MatricularAluno('Diego', 'Ferreira', 'Engenharia de Petróleo', 'Engenharia');
CALL MatricularAluno('Mariana', 'Pereira', 'Antropologia', 'Ciências Humanas');
CALL MatricularAluno('Gustavo', 'Silva', 'Enfermagem', 'Saúde');
CALL MatricularAluno('Carolina', 'Almeida', 'Engenharia de Software', 'Tecnologia');
CALL MatricularAluno('Vinícius', 'Martins', 'Arquitetura e Urbanismo', 'Artes');
CALL MatricularAluno('Tatiane', 'Silva', 'Engenharia de Produção', 'Engenharia');
CALL MatricularAluno('Fernando', 'Ferreira', 'Teatro', 'Ciências Humanas');
CALL MatricularAluno('Luciana', 'Oliveira', 'Fisioterapia', 'Saúde');
CALL MatricularAluno('Roberto', 'Almeida', 'Terapia Ocupacional', 'Saúde');
CALL MatricularAluno('Camila', 'Rocha', 'Animação Digital', 'Tecnologia');
CALL MatricularAluno('Gustavo', 'Silva', 'Gastronomia', 'Artes');
CALL MatricularAluno('Bianca', 'Fernandes', 'Engenharia de Minas', 'Engenharia');
CALL MatricularAluno('Lucas', 'Mendes', 'Letras', 'Ciências Humanas');
CALL MatricularAluno('Ana', 'Costa', 'Fonoaudiologia', 'Saúde');
CALL MatricularAluno('Rafael', 'Oliveira', 'Ciências da Computação', 'Tecnologia');
CALL MatricularAluno('Aline', 'Santos', 'Moda', 'Artes');
CALL MatricularAluno('Bruno', 'Rodrigues', 'Engenharia de Petróleo', 'Engenharia');
CALL MatricularAluno('Mariana', 'Ferreira', 'Antropologia', 'Ciências Humanas');
CALL MatricularAluno('José', 'Pinto', 'Enfermagem', 'Saúde');
CALL MatricularAluno('Carla', 'Souza', 'Engenharia de Software', 'Tecnologia');
CALL MatricularAluno('Ricardo', 'Fernandes', 'Arquitetura e Urbanismo', 'Artes');
CALL MatricularAluno('Mariana', 'Costa', 'Engenharia Química', 'Engenharia');
CALL MatricularAluno('João', 'Silveira', 'Sociologia', 'Ciências Humanas');
CALL MatricularAluno('Patrícia', 'Oliveira', 'Medicina Veterinária', 'Saúde');
CALL MatricularAluno('Luiz', 'Martins', 'Gestão da Tecnologia da Informação', 'Tecnologia');
CALL MatricularAluno('Amanda', 'Pereira', 'Cinema', 'Artes');
CALL MatricularAluno('Rodrigo', 'Santos', 'Engenharia Biomédica', 'Engenharia');
CALL MatricularAluno('Fernanda', 'Gonçalves', 'Jornalismo', 'Ciências Humanas');

-- Consultar todos os e-mails dos alunos
SELECT nome, sobrenome, email FROM Alunos;
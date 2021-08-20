import UIKit

protocol Aluguel {
  func retornar(exemplar: String) -> String
  func alugar(exemplar: Filme)
  func alugado(exemplar: Filme) -> Bool
  func usar(exemplar: Filme)
  func usado(exemplar: Vhs) -> Bool
}

class Locadora: Aluguel {
    
    private var filmes : [Filme]
    private let funcionario : Funcionario
    
    init (filmes : [Filme], funcionario:Funcionario){
        self.filmes = filmes
        self.funcionario = funcionario
        
        self.funcionario.delegate = self
    }
    
    func retornar(exemplar: String) -> String {
        return exemplar
    }

    func alugar(exemplar: Filme){
        if let vhs = exemplar as? Vhs { //Momento que é feito um downcasting de Filme para Vhs, se for vhs não poderá ser alugado.
            print ("Erro: O filme \(vhs.titulo) não pode ser alugado pois é um vhs.")
        } else { //Senão é Vhs, pode ser alugado
            if alugado(exemplar: exemplar) {
                print ("Erro: O filme \(exemplar.titulo) já está alugado.")
            } else {
                exemplar.alugado = true
                print ("Sucesso: O filme \(exemplar.titulo) foi alugado.")
            }
        }
    }

    func alugado(exemplar: Filme) -> Bool {
        return exemplar.alugado
    }

    func usar(exemplar: Filme){
        if let vhs = exemplar as? Vhs{ //Momento que é feito o downcasting de Filme para Vhs
            if usado(exemplar: vhs){
                print ("Erro: O filme '\(vhs.titulo)' já está sendo usado.")
            } else {
                vhs.usado = true
                print ("Sucesso: O filme '\(vhs.titulo)' foi usado.")
            }
        } else{
            print ("Erro: O filme '\(exemplar.titulo)' não é um VHS.")
        }
    }

    func usado(exemplar: Vhs) -> Bool {
        return exemplar.usado
    }
    
    func statusFilmes() {
        print("\n==============Status dos Filmes==============")
        for filme in self.filmes{
            var status : String
            
            if let vhs = filme as? Vhs {
                status = vhs.usado ? "usado" : "disponivel para usar" // if ternário
            } else {
                status = filme.alugado ? "alugado" : "disponivel para alugar" // if ternário
            }
            
            print ("O filme '\(filme.titulo)' está \(status)")
        }
        print("=============================================\n")
    }
}

class Funcionario {
    private var nome : String
    var delegate : Aluguel?
    
    init(nome: String) {
        self.nome = nome
    }
    
    func alugaExemplar(exemplar: Filme){
        print ("\nO funcionario \(self.nome) está tentando alugar o filme '\(exemplar.titulo)'")
        delegate?.alugar(exemplar: exemplar)
    }
    
    func usaVHS(filmeVhs : Filme) {
        print ("\nO funcionario \(self.nome) está tentando usar o filme '\(filmeVhs.titulo)'")
        delegate?.usar(exemplar: filmeVhs)
    }
}

class Filme {
    public let imdb: Int
    public let titulo: String
    public let anoDeLancamento: Int
    public let idiomaDasLegendas: [String]
    public var alugado: Bool

    init(imdb: Int, titulo: String, anoDeLancamento: Int, idiomaDasLegendas: [String], alugado: Bool) {
        self.imdb = imdb
        self.titulo = titulo
        self.anoDeLancamento = anoDeLancamento
        self.idiomaDasLegendas = idiomaDasLegendas
        self.alugado = alugado
    }
}

class Dvd: Filme {
    private var zona: String
  
    init(zona: String, imdb: Int, titulo: String, anoDeLancamento: Int, idiomaDasLegendas: [String], alugado: Bool) {
        self.zona = zona
        super.init(imdb: imdb, titulo: titulo, anoDeLancamento: anoDeLancamento, idiomaDasLegendas: idiomaDasLegendas, alugado: alugado)
    }
}

class Vhs: Filme {
    public var usado: Bool
    private let dataDeFabricacao: Int
    
    init(usado: Bool, dataDeFabricacao: Int, imdb: Int, titulo: String, anoDeLancamento: Int, idiomaDasLegendas: [String]) {
        self.usado = usado
        self.dataDeFabricacao = dataDeFabricacao
        super.init(imdb: imdb, titulo: titulo, anoDeLancamento: anoDeLancamento, idiomaDasLegendas: idiomaDasLegendas, alugado: false)
    }
}

enum Capacidade {
    case vinteCincoGB
    case cinquentaGB
    case cemGB
    case duzentosGB
}

class Bluray: Filme {
    public let capacidade : Capacidade
    
    init(capacidade: Capacidade, imdb: Int, titulo: String, anoDeLancamento: Int, idiomaDasLegendas: [String], alugado: Bool) {
        self.capacidade = capacidade
        super.init(imdb: imdb, titulo: titulo, anoDeLancamento: anoDeLancamento, idiomaDasLegendas: idiomaDasLegendas, alugado: alugado)
    }
}


var filmes : [Filme] = [
    Dvd(zona: "zona1", imdb: 345, titulo: "Nos tempos da brilhantina", anoDeLancamento: 1960, idiomaDasLegendas: ["Ingles", "Portugues"], alugado:false),
    Bluray(capacidade: .cinquentaGB, imdb: 456, titulo: "Senhor dos anéis", anoDeLancamento: 2001, idiomaDasLegendas: ["Ingles", "Portugues", "Espanhol"], alugado: false),
    Vhs(usado: false, dataDeFabricacao: 1992, imdb: 234, titulo: "O Rei Leão", anoDeLancamento: 1992, idiomaDasLegendas: ["Ingles", "Portugues", "Espanhol"])
]

let hmmb = Funcionario(nome: "Henry Miller")

let blowBuster = Locadora(filmes: filmes, funcionario: hmmb)

blowBuster.statusFilmes()

for filme in filmes {
    hmmb.alugaExemplar(exemplar: filme)
}

blowBuster.statusFilmes()

for filme in filmes{
    hmmb.usaVHS(filmeVhs: filme)
}

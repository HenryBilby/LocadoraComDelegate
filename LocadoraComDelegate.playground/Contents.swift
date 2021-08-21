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
        if !alugado(exemplar: exemplar){
            if let dvd = exemplar as? Dvd {
                dvd.alugado = true
                print ("Sucesso: O filme '\(dvd.titulo)' foi alugado.")
            } else if let bluray = exemplar as? Bluray {
                bluray.alugado = true
                print ("Sucesso: O filme '\(bluray.titulo)' foi alugado.")
            } else {
                print ("Erro: O filme '\(exemplar.titulo)' não pode ser alugado.")
            }
        } else {
            print("Erro: O filme '\(exemplar.titulo)' já está alugado.")
        }
    }

    func alugado(exemplar: Filme) -> Bool {
        if let dvd = exemplar as? Dvd{
            return dvd.alugado
        }
        
        if let bluray = exemplar as? Bluray{
            return bluray.alugado
        }
        
        return false
    }

    func usar(exemplar: Filme){
        if let vhs = exemplar as? Vhs{
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
            var status : String = "disponível"
            
            if let vhs = filme as? Vhs {
                status = vhs.usado ? "sendo usado" : "disponivel para usar"
            }
            if let dvd = filme as? Dvd {
                status = dvd.alugado ? "alugado" : "disponivel para alugar"
            }
            if let bluray = filme as? Bluray {
                status = bluray.alugado ? "alugado" : "disponivel para alugar"
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

    init(imdb: Int, titulo: String, anoDeLancamento: Int, idiomaDasLegendas: [String]) {
        self.imdb = imdb
        self.titulo = titulo
        self.anoDeLancamento = anoDeLancamento
        self.idiomaDasLegendas = idiomaDasLegendas
    }
}

class Dvd: Filme {
    private var zona: String
    public var alugado: Bool = false
  
    init(zona: String, imdb: Int, titulo: String, anoDeLancamento: Int, idiomaDasLegendas: [String]) {
        self.zona = zona
        super.init(imdb: imdb, titulo: titulo, anoDeLancamento: anoDeLancamento, idiomaDasLegendas: idiomaDasLegendas)
    }
}

class Vhs: Filme {
    public var usado: Bool
    private let dataDeFabricacao: Int
    
    init(usado: Bool, dataDeFabricacao: Int, imdb: Int, titulo: String, anoDeLancamento: Int, idiomaDasLegendas: [String]) {
        self.usado = usado
        self.dataDeFabricacao = dataDeFabricacao
        super.init(imdb: imdb, titulo: titulo, anoDeLancamento: anoDeLancamento, idiomaDasLegendas: idiomaDasLegendas)
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
    public var alugado : Bool = false
    
    init(capacidade: Capacidade, imdb: Int, titulo: String, anoDeLancamento: Int, idiomaDasLegendas: [String]) {
        self.capacidade = capacidade
        super.init(imdb: imdb, titulo: titulo, anoDeLancamento: anoDeLancamento, idiomaDasLegendas: idiomaDasLegendas)
    }
}


var filmes : [Filme] = [
    Dvd(zona: "zona1", imdb: 345, titulo: "Nos tempos da brilhantina", anoDeLancamento: 1960, idiomaDasLegendas: ["Ingles", "Portugues"]),
    Bluray(capacidade: .cinquentaGB, imdb: 456, titulo: "Senhor dos anéis", anoDeLancamento: 2001, idiomaDasLegendas: ["Ingles", "Portugues", "Espanhol"]),
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

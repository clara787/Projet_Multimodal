import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;

Thread thread1, thread2;
Process process1, process2;
boolean thread1Running = true;
boolean thread2Running = true;

void lancement_python(){
  // Chemins des fichiers Python
    String pythonScript1 = sketchPath("./PyMove/PyMove.py");
    String pythonScript2 = sketchPath("./pyVocal/PyVocal.py");

    // Créer et démarrer les threads pour lancer les fichiers Python
    thread1 = new Thread(new Runnable() {
        public void run() {
            lancerPython(pythonScript1, 1);
        }
    });
    thread1.start();

    thread2 = new Thread(new Runnable() {
        public void run() {
            lancerPython(pythonScript2, 2);
        }
    });
    thread2.start();
}

void lancerPython(String scriptPath, int threadId) {
    try {
        // Créer le processus pour exécuter le script Python dans un terminal
        ProcessBuilder pb = new ProcessBuilder("cmd", "/c", "start", "python", scriptPath);
        pb.directory(new File(sketchPath()));  // Optionnel: Répertoire de travail du projet Processing
        pb.redirectErrorStream(true);

        Process process = pb.start();
        
        // Enregistrer le processus pour pouvoir l'arrêter plus tard
        if (threadId == 1) {
            process1 = process;
        } else if (threadId == 2) {
            process2 = process;
        }

        // Lire la sortie du script Python
        BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
        String line;
        while ((line = reader.readLine()) != null) {
            println(line);
        }

        process.waitFor();
    } catch (IOException | InterruptedException e) {
        e.printStackTrace();
    } finally {
        // Marquer le thread comme terminé
        if (threadId == 1) {
            thread1Running = false;
        } else if (threadId == 2) {
            thread2Running = false;
        }
    }
}

// Méthode pour arrêter le thread et tuer le processus
void stopThread(int threadId) {
    if (threadId == 1 && thread1Running) {
        println("Arrêt du thread 1 et du processus...");
        if (process1 != null) {
            process1.destroy();  // Tuer le processus Python
        }
        thread1Running = false; // Marquer le thread comme arrêté
    }

    if (threadId == 2 && thread2Running) {
        println("Arrêt du thread 2 et du processus...");
        if (process2 != null) {
            process2.destroy();  // Tuer le processus Python
        }
        thread2Running = false; // Marquer le thread comme arrêté
    }
}

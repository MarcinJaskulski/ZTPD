import java.io.IOException;

import com.espertech.esper.common.client.configuration.Configuration;
import com.espertech.esper.runtime.client.EPRuntime;
import com.espertech.esper.runtime.client.EPRuntimeProvider;
import com.espertech.esper.common.client.EPCompiled;
import com.espertech.esper.compiler.client.CompilerArguments;
import com.espertech.esper.compiler.client.EPCompileException;
import com.espertech.esper.compiler.client.EPCompilerProvider;
import com.espertech.esper.runtime.client.*;

public class Main {
    public static void main(String[] args) throws IOException {
        Configuration configuration = new Configuration();
        configuration.getCommon().addEventType(KursAkcji.class);
        EPRuntime epRuntime = EPRuntimeProvider.getDefaultRuntime(configuration);

//*****************ZADANIE 23*********************//
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//                "SELECT irstream spolka as X, kursOtwarcia as Y " +
//                        "FROM KursAkcji.win:length(3) ");
// Zapytanie opiera się na oknie o długości trzech zdarzeń.
// Czyli jeśli wchodzi Apple, następnie 3 zdarzenia i Apple jest usuwane/ zapominane


//*****************ZADANIE 24*********************//
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//                "SELECT IRSTREAM spolka as X, kursOtwarcia as Y " +
//                    "FROM KursAkcji.win:length(3) " +
//                    "WHERE spolka = 'Oracle'");
// odp: Klauzula WHERE słyży tylko do filtrowania strumienia. Nie ma wpływu na okno, tzn. wszytskie przychodzące komunikaty
// licza się do okna, a komunikaty nastpenie sa filtrowane przez WHERE.

//*****************ZADANIE 25*********************//
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//            "SELECT IRSTREAM data, kursOtwarcia, spolka " +
//                "FROM KursAkcji.win:length(3) " +
//                "WHERE spolka = 'Oracle'");


//*****************ZADANIE 26*********************//
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//            "SELECT IRSTREAM data, kursOtwarcia, spolka " +
//                "FROM KursAkcji(spolka='Oracle').win:length(3) ");


//*****************ZADANIE 27*********************//
// Wyłaczenie generowania wynikowego strumienia zdarzeń usuwanych  - nie będzie RSTREAM
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//        "SELECT ISTREAM data, kursOtwarcia, spolka " +
//            "FROM KursAkcji(spolka='Oracle').win:length(3) ");

//*****************ZADANIE 28*********************//
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//        "SELECT ISTREAM MAX(kursOtwarcia) " +
//            "FROM KursAkcji(spolka='Oracle').win:length(5) ");

//*****************ZADANIE 29*********************//
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//        "SELECT ISTREAM kursOtwarcia - MAX(kursOtwarcia) AS roznica " +
//            "FROM KursAkcji(spolka='Oracle').win:length(5) ");
// Odp. Funkcja max bierze największa wartość z okna (tutaj 5 wartości), a nie z całego zbioru.

//*****************ZADANIE 30*********************//
            EPDeployment deployment = compileAndDeploy(epRuntime,
            "SELECT ISTREAM data, spolka, kursOtwarcia - MIN(kursOtwarcia) AS roznica " +
                "FROM KursAkcji(spolka='Oracle').win:length(2) " +
                "HAVING kursOtwarcia > MIN(kursOtwarcia)");

// Odp: Uzyskany wynik jest poprawny, widzimy tylko wzrost.

        ProstyListener prostyListener = new ProstyListener();

        for (EPStatement statement : deployment.getStatements()) {
            statement.addListener(prostyListener);
        }

        InputStream inputStream = new InputStream();
        inputStream.generuj(epRuntime.getEventService());
    }

    public static EPDeployment compileAndDeploy(EPRuntime epRuntime, String epl) {
        EPDeploymentService deploymentService = epRuntime.getDeploymentService();

        CompilerArguments args = new CompilerArguments(epRuntime.getConfigurationDeepCopy());
        EPDeployment deployment;
        try {
            EPCompiled epCompiled = EPCompilerProvider.getCompiler().compile(epl, args);
            deployment = deploymentService.deploy(epCompiled);
        } catch (EPCompileException e) {
            throw new RuntimeException(e);
        } catch (EPDeployException e) {
            throw new RuntimeException(e);
        }
        return deployment;
    }
}
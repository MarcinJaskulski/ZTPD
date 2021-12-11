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

//*****************ZADANIE 2A*********************//
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//            "select irstream data, kursZamkniecia, max(kursZamkniecia)" +
//                "from KursAkcji(spolka = 'Oracle').win:ext_timed(data.getTime(), 7 days)");

//*****************ZADANIE 2B*********************//
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//            "select irstream data, kursZamkniecia, max(kursZamkniecia)" +
//                "from KursAkcji(spolka = 'Oracle').win:ext_timed_batch(data.getTime(), 7 days)");


//*****************ZADANIE 5*********************//
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//            "select istream data, kursZamkniecia, spolka, max(kursZamkniecia) - kursZamkniecia as roznica " +
//            "from KursAkcji.win:ext_timed_batch(data.getTime(), 1 days)");

//*****************ZADANIE 6*********************//
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//        "select istream data, kursZamkniecia, spolka, max(kursZamkniecia) - kursZamkniecia as roznica " +
//            "from KursAkcji(spolka in ('Honda', 'IBM', 'Microsoft')).win:ext_timed_batch(data.getTime(), 1 days)");

//*****************ZADANIE 7A*********************//
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//        "select istream data, kursOtwarcia, kursZamkniecia, spolka " +
//            "from KursAkcji.win:length(1)" +
//            "where kursZamkniecia > kursOtwarcia");

//*****************ZADANIE 7B*********************//
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//        "select istream data, kursOtwarcia, kursZamkniecia, spolka " +
//            "from KursAkcji(KursAkcji.roznicaKursow(kursOtwarcia, kursZamkniecia) > 0).win:length(1)");

//*****************ZADANIE 8*********************//
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//            "select istream data, spolka, kursZamkniecia, max(kursZamkniecia) - kursZamkniecia as roznica " +
//            "from KursAkcji(spolka in ('PepsiCo', 'CocaCola')).win:ext_timed(data.getTime(), 7 days)");

//*****************ZADANIE 9*********************//
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//        "select istream data, spolka, kursZamkniecia, max(kursZamkniecia) " +
//            "from KursAkcji(spolka in ('PepsiCo', 'CocaCola')).win:ext_timed_batch(data.getTime(), 1 days)" +
//            "having max(kursZamkniecia) = kursZamkniecia");

//*****************ZADANIE 10*********************//
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//        "select istream max(kursZamkniecia) as maksimum " +
//            "from KursAkcji.win:ext_timed_batch(data.getTime(), 7 days)");

//*****************ZADANIE 11*********************//
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//        "select istream pep.kursZamkniecia as kursPep, coc.kursZamkniecia as kursCoc, pep.data " +
//            "from KursAkcji(spolka = 'CocaCola').win:length(1) as coc join " +
//            "KursAkcji(spolka = 'PepsiCo').win:length(1) as pep " +
//            "on coc.data = pep.data " +
//            "where pep.kursZamkniecia > coc.kursZamkniecia");

//*****************ZADANIE 12*********************//
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//        "select istream a.spolka, a.data, a.kursZamkniecia as kursBiezacy, a.kursZamkniecia - b.kursZamkniecia as roznica " +
//            "from KursAkcji(spolka in ('PepsiCo', 'CocaCola')).win:length(1) as a join " +
//            "KursAkcji(spolka in ('PepsiCo', 'CocaCola')).std:firstunique(spolka) as b " +
//            "on a.spolka = b.spolka");

//*****************ZADANIE 13*********************//
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//        "select istream a.spolka, a.data, a.kursZamkniecia as kursBiezacy, a.kursZamkniecia - b.kursZamkniecia as roznica " +
//            "from KursAkcji.win:length(1) as a join " +
//            "KursAkcji.std:firstunique(spolka) as b " +
//            "on a.spolka = b.spolka " +
//            "where a.kursZamkniecia > b.kursZamkniecia");

//*****************ZADANIE 14*********************//
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//        "select istream a.data, b.data, a.spolka, a.kursOtwarcia, b.kursOtwarcia " +
//            "from KursAkcji.win:ext_timed(data.getTime(), 7 days) as a join " +
//            "KursAkcji.win:ext_timed(data.getTime(), 7 days) as b " +
//            "on a.spolka = b.spolka " +
//            "where a.kursOtwarcia - b.kursOtwarcia > 3");

//*****************ZADANIE 15*********************//
//        EPDeployment deployment = compileAndDeploy(epRuntime,
//        "select istream data, spolka, obrot " +
//            "from KursAkcji(market = 'NYSE').win:ext_timed_batch(data.getTime(), 7 days) " +
//            "order by obrot desc limit 3");

//*****************ZADANIE 16*********************//
        EPDeployment deployment = compileAndDeploy(epRuntime,
        "select istream data, spolka, obrot " +
            "from KursAkcji(market = 'NYSE').win:ext_timed_batch(data.getTime(), 7 days) " +
            "order by obrot desc limit 2, 1");

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
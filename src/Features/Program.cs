// Modifications to this file are Copyright (c) 2021 Drew Naylor and
// are available under the MIT License, just like the original code.



using System;
using System.IO;
using Qml.Net;
using Qml.Net.Runtimes;

namespace Features
{
    class Program
    {
        static int Main(string[] args)
        {
            RuntimeManager.DiscoverOrDownloadSuitableQtRuntime();
            
            QQuickStyle.SetStyle("Universal");

            using (var application = new QGuiApplication(args))
            {
                using (var qmlEngine = new QQmlApplicationEngine())
                {
                    Qml.Net.Qml.RegisterType<SignalsModel>("Features");
                    Qml.Net.Qml.RegisterType<NotifySignalsModel>("Features");
                    Qml.Net.Qml.RegisterType<AsyncAwaitModel>("Features");
                    Qml.Net.Qml.RegisterType<NetObjectsModel>("Features");
                    Qml.Net.Qml.RegisterType<DynamicModel>("Features");
                    Qml.Net.Qml.RegisterType<CalculatorModel>("Features");
                    Qml.Net.Qml.RegisterType<CollectionsModel>("Features");

                    qmlEngine.Load("Main.qml");
                    
                    return application.Exec();
                }
            }
        }
    }
}

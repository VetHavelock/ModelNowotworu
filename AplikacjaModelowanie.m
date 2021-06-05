classdef AplikacjaModelowanie < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                   matlab.ui.Figure
        UIAxes                     matlab.ui.control.UIAxes
        RodzajmodeluDropDownLabel  matlab.ui.control.Label
        RodzajmodeluDropDown       matlab.ui.control.DropDown
        ParametrynowotworuPanel    matlab.ui.container.Panel
        l1Label                    matlab.ui.control.Label
        lambda1Field               matlab.ui.control.NumericEditField
        l2Label                    matlab.ui.control.Label
        lambda2Field               matlab.ui.control.NumericEditField
        V2Label                    matlab.ui.control.Label
        V2Field                    matlab.ui.control.NumericEditField
        V1EditFieldLabel           matlab.ui.control.Label
        V1Field                    matlab.ui.control.NumericEditField
        b2Label                    matlab.ui.control.Label
        b2Field                    matlab.ui.control.NumericEditField
        b1EditFieldLabel           matlab.ui.control.Label
        b1Field                    matlab.ui.control.NumericEditField
        a21Label                   matlab.ui.control.Label
        alpha21Field               matlab.ui.control.NumericEditField
        a12Label                   matlab.ui.control.Label
        alpha12Field               matlab.ui.control.NumericEditField
        miLabel                    matlab.ui.control.Label
        miField                    matlab.ui.control.NumericEditField
        dEditFieldLabel            matlab.ui.control.Label
        dField                     matlab.ui.control.NumericEditField
        KEditFieldLabel            matlab.ui.control.Label
        KField                     matlab.ui.control.NumericEditField
        tsLabel                    matlab.ui.control.Label
        tsField                    matlab.ui.control.NumericEditField
        ParametryleczeniaPanel     matlab.ui.container.Panel
        eEditFieldLabel            matlab.ui.control.Label
        eField                     matlab.ui.control.NumericEditField
        clrLabel                   matlab.ui.control.Label
        clrField                   matlab.ui.control.NumericEditField
        DLabel                     matlab.ui.control.Label
        DField                     matlab.ui.control.NumericEditField
        PocztekLabel               matlab.ui.control.Label
        BeginField                 matlab.ui.control.NumericEditField
        CzstoLabel                 matlab.ui.control.Label
        freqField                  matlab.ui.control.NumericEditField
        ObliczButton               matlab.ui.control.Button
    end

    
    properties (Access = private)
        lambda1 % Description
        lambda2 % Description
        V1 % Description
        V2 % Description
        b1 % Description
        b2 % Description
        alpha12 % Description
        alpha21 % Description
        d % Description
        mi % Description
        e % Description
        K % Description
        model % Description
        ts % Description
        clr % Description
        D % Description
        begin % Description
        freq % Description
    end
    methods
        function Rysuj(app)
            switch app.model
                case "gompertz"
                    [T,dK,dV]=ModelGompertza(app);
                    plot(app.UIAxes,T,dV,'DisplayName','V')
                    hold(app.UIAxes,'on') 
                    plot(app.UIAxes,T,dK,'DisplayName','K')
                    legend(app.UIAxes)
                    hold(app.UIAxes,'off')
                case "hahnfeldt"
                    [T,dK,dV]=ModelHahnfeldta(app);
                    plot(app.UIAxes,T,dV,'DisplayName','V')
                    hold(app.UIAxes,'on') 
                    plot(app.UIAxes,T,dK,'DisplayName','K')
                    legend(app.UIAxes)
                    hold(app.UIAxes,'off')
                case "leczenie"
                    [T,dK,dV]=ModelHahnfeldtaZLeczeniem(app);
                    plot(app.UIAxes,T,dV,'DisplayName','V')
                    hold(app.UIAxes,'on') 
                    plot(app.UIAxes,T,dK,'DisplayName','K')
                    legend(app.UIAxes)
                    hold(app.UIAxes,'off')
                case "konkurencja"
                    [T,dK,dV1,dV2]=ModelHahnfeldtaZKonkurencja(app);
                    plot(app.UIAxes,T,dV1,'DisplayName','V1')
                    hold(app.UIAxes,'on') 
                    plot(app.UIAxes,T,dV2,'DisplayName','V2')
                    plot(app.UIAxes,T,dK,'DisplayName','K')
                    legend(app.UIAxes)
                    hold(app.UIAxes,'off')
            end
            
            
            
            
          
            
        end
        function [T,dK,dV] = ModelGompertza(app)
            x=app.V1;
            y = [app.lambda1, app.K];
            [T,X] = ode45(@(t,V)app.RownaniaGompertza(t,V,y),[0 app.ts],x);
            dK = zeros(size(T));
            dK(dK==0)=app.K;
            dV = X;
        end
        
        function [T,dK,dV] = ModelHahnfeldta(app)
            x = [app.V1,app.K];
            y = [app.lambda1, app.mi, app.b1, app.d];
            [T,X] = ode45(@(t,x) app.RownaniaHahnfeldta(t,x,y),[0 app.ts],x);
            dV = X(:,1);
            dK=X(:,2);
        end
        
        
       
        
        function [T,dK,dV] = ModelHahnfeldtaZLeczeniem(app)
            x = [app.V1,app.K];
            y = [app.lambda1, app.mi, app.b1, app.d, app.begin, app.freq, app.e, app.D, app.clr, app.ts];
            [T,X] = ode45(@(t,x) app.RownaniaHahnfeldtaZLeczeniem(t,x,y),[0 app.ts],x);
            dV = X(:,1);
            dK=X(:,2);
        end
        
        function [T,dK,dV1,dV2] = ModelHahnfeldtaZKonkurencja(app)
            x = [app.V1,app.V2, app.K];
            y = [app.lambda1, app.mi, app.b1, app.d, app.lambda2, app.b2, app.alpha12,app.alpha21];
            [T,X] = ode45(@(t,x) app.RownaniaHahnfeldtaZKonkurencja(t,x,y),[0 app.ts],x);
            dV1 = X(:,1);
            dV2 = X(:,2);
            dK=X(:,3);
        end
        
    end
    methods (Static)
        
    
   
        function dV = RownaniaGompertza(t,V,y)
            l = y(1);
            K1 = y(2);
            dV = -l*V*log(V/K1);
        end
        
        function wynik = RownaniaHahnfeldta(t,x,y)
            V = x(1);
            K1 = x(2);
            l = y(1);
            m = y(2);
            b = y(3);
            d1 = y(4);
            dV = -l*V*log(V*K1^(-1));
            dK = -m*K1+b*V-d1*V^(2/3)*K1;
            wynik = [dV; dK];
        end
         function wynik = RownaniaHahnfeldtaZLeczeniem(t,x,y)
            V = x(1);
            K1 = x(2);
            l = y(1);
            m = y(2);
            b = y(3);
            d1 = y(4);%app.begin, app.frq, app.e, app.D, app.clr
            begin = y(5);
            freq = y(6);
            e = y(7);
            D = y(8);
            clr = y(9);
            koniec = y(10);
            
            T = begin:freq:koniec;
            
            syms s;
            f1 = sum(dirac(s-T));
            f2 = exp(-clr*(t-s));
            f3 = D*f1*f2;
            g = int(f3,s,[0 t]);
            dV = -l*V*log(V/K1);
            dK = -m*K1+b*V-d1*K1*V^(2/3)-e*K1*g;
            wynik = [double(dV);double(dK)];
        end
        
        function wynik = RownaniaHahnfeldtaZKonkurencja(t,x,y)
            V = x(1);
            Vb = x(2);
            K1 = x(3);
            l = y(1);
            m = y(2);
            b = y(3);
            d1 = y(4);%app.lambda2, app.b2, app.alpha12,app.alpha21
            lb = y(5);
            bb = y(6);
            a12 = y(7);
            a21 = y(8);
            
            dV1 = -l*V*log((V+a12*Vb)*K1^(-1));
            dV2 = -lb*Vb*log((Vb+a21*V)*K1^(-1));
            dK = -m*K1+b*V+bb*Vb-d1*(V+Vb)^(2/3)*K1;
            wynik = [dV1; dV2; dK];
        end
end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: ObliczButton
        function ObliczButtonPushed(app, event)
            app.lambda1 = app.lambda1Field.Value;
            app.lambda2 = app.lambda2Field.Value;
            app.V1 = app.V1Field.Value;
            app.V2 = app.V2Field.Value;
            app.b1 = app.b1Field.Value;
            app.b2 = app.b2Field.Value;
            app.alpha12 = app.alpha21Field.Value;
            app.alpha21 = app.alpha21Field.Value;
            app.d = app.dField.Value;
            app.mi = app.miField.Value;
            app.e = app.eField.Value; 
            app.ts = app.tsField.Value;
            app.model = app.RodzajmodeluDropDown.Value;
            app.K = app.KField.Value;
            app.clr = app.clrField.Value;
            app.D = app.DField.Value;
            app.begin = app.BeginField.Value;
            app.freq = app.freqField.Value;
            Rysuj(app);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'Przebiegi w czasie V i K')
            xlabel(app.UIAxes, {'Czas [dni]'; ''})
            ylabel(app.UIAxes, 'Objêtoœæ [mm^3]')
            app.UIAxes.Position = [32 55 382 338];

            % Create RodzajmodeluDropDownLabel
            app.RodzajmodeluDropDownLabel = uilabel(app.UIFigure);
            app.RodzajmodeluDropDownLabel.HorizontalAlignment = 'right';
            app.RodzajmodeluDropDownLabel.Position = [11 424 86 22];
            app.RodzajmodeluDropDownLabel.Text = 'Rodzaj modelu';

            % Create RodzajmodeluDropDown
            app.RodzajmodeluDropDown = uidropdown(app.UIFigure);
            app.RodzajmodeluDropDown.Items = {'Model Gompertza', 'Model Hahnfeldta', 'Model Hahnfeldta z leczeniem', 'Model Hahnfeldta z konkurencjÿ'};
            app.RodzajmodeluDropDown.ItemsData = {'gompertz', 'hahnfeldt', 'leczenie', 'konkurencja'};
            app.RodzajmodeluDropDown.Position = [112 424 490 22];
            app.RodzajmodeluDropDown.Value = 'gompertz';

            % Create ParametrynowotworuPanel
            app.ParametrynowotworuPanel = uipanel(app.UIFigure);
            app.ParametrynowotworuPanel.Title = 'Parametry nowotworu';
            app.ParametrynowotworuPanel.Position = [419 192 183 219];

            % Create l1Label
            app.l1Label = uilabel(app.ParametrynowotworuPanel);
            app.l1Label.HorizontalAlignment = 'right';
            app.l1Label.Position = [1 170 25 22];
            app.l1Label.Text = 'l1';

            % Create lambda1Field
            app.lambda1Field = uieditfield(app.ParametrynowotworuPanel, 'numeric');
            app.lambda1Field.Position = [41 170 49 22];
            app.lambda1Field.Value = 0.0741;

            % Create l2Label
            app.l2Label = uilabel(app.ParametrynowotworuPanel);
            app.l2Label.HorizontalAlignment = 'right';
            app.l2Label.Position = [89 170 25 22];
            app.l2Label.Text = 'l2';

            % Create lambda2Field
            app.lambda2Field = uieditfield(app.ParametrynowotworuPanel, 'numeric');
            app.lambda2Field.Position = [129 170 49 22];

            % Create V2Label
            app.V2Label = uilabel(app.ParametrynowotworuPanel);
            app.V2Label.HorizontalAlignment = 'right';
            app.V2Label.Position = [89 140 25 22];
            app.V2Label.Text = 'V2';

            % Create V2Field
            app.V2Field = uieditfield(app.ParametrynowotworuPanel, 'numeric');
            app.V2Field.Position = [129 140 49 22];

            % Create V1EditFieldLabel
            app.V1EditFieldLabel = uilabel(app.ParametrynowotworuPanel);
            app.V1EditFieldLabel.HorizontalAlignment = 'right';
            app.V1EditFieldLabel.Position = [1 140 25 22];
            app.V1EditFieldLabel.Text = 'V1';

            % Create V1Field
            app.V1Field = uieditfield(app.ParametrynowotworuPanel, 'numeric');
            app.V1Field.Position = [41 140 49 22];
            app.V1Field.Value = 71;

            % Create b2Label
            app.b2Label = uilabel(app.ParametrynowotworuPanel);
            app.b2Label.HorizontalAlignment = 'right';
            app.b2Label.Position = [89 106 25 22];
            app.b2Label.Text = 'b2';

            % Create b2Field
            app.b2Field = uieditfield(app.ParametrynowotworuPanel, 'numeric');
            app.b2Field.Position = [129 106 49 22];

            % Create b1EditFieldLabel
            app.b1EditFieldLabel = uilabel(app.ParametrynowotworuPanel);
            app.b1EditFieldLabel.HorizontalAlignment = 'right';
            app.b1EditFieldLabel.Position = [1 106 25 22];
            app.b1EditFieldLabel.Text = 'b1';

            % Create b1Field
            app.b1Field = uieditfield(app.ParametrynowotworuPanel, 'numeric');
            app.b1Field.Position = [41 106 49 22];
            app.b1Field.Value = 1.3383;

            % Create a21Label
            app.a21Label = uilabel(app.ParametrynowotworuPanel);
            app.a21Label.HorizontalAlignment = 'right';
            app.a21Label.Position = [88 75 26 22];
            app.a21Label.Text = 'a21';

            % Create alpha21Field
            app.alpha21Field = uieditfield(app.ParametrynowotworuPanel, 'numeric');
            app.alpha21Field.Position = [129 75 49 22];

            % Create a12Label
            app.a12Label = uilabel(app.ParametrynowotworuPanel);
            app.a12Label.HorizontalAlignment = 'right';
            app.a12Label.Position = [1 75 26 22];
            app.a12Label.Text = 'a12';

            % Create alpha12Field
            app.alpha12Field = uieditfield(app.ParametrynowotworuPanel, 'numeric');
            app.alpha12Field.Position = [41 75 49 22];

            % Create miLabel
            app.miLabel = uilabel(app.ParametrynowotworuPanel);
            app.miLabel.HorizontalAlignment = 'right';
            app.miLabel.Position = [89 39 25 22];
            app.miLabel.Text = 'mi';

            % Create miField
            app.miField = uieditfield(app.ParametrynowotworuPanel, 'numeric');
            app.miField.Position = [129 39 49 22];
            app.miField.Value = 0.0021;

            % Create dEditFieldLabel
            app.dEditFieldLabel = uilabel(app.ParametrynowotworuPanel);
            app.dEditFieldLabel.HorizontalAlignment = 'right';
            app.dEditFieldLabel.Position = [2 39 25 22];
            app.dEditFieldLabel.Text = 'd';

            % Create dField
            app.dField = uieditfield(app.ParametrynowotworuPanel, 'numeric');
            app.dField.Position = [42 39 49 22];
            app.dField.Value = 0.002;

            % Create KEditFieldLabel
            app.KEditFieldLabel = uilabel(app.ParametrynowotworuPanel);
            app.KEditFieldLabel.HorizontalAlignment = 'right';
            app.KEditFieldLabel.Position = [2 10 25 22];
            app.KEditFieldLabel.Text = 'K';

            % Create KField
            app.KField = uieditfield(app.ParametrynowotworuPanel, 'numeric');
            app.KField.Position = [42 10 49 22];
            app.KField.Value = 71;

            % Create tsLabel
            app.tsLabel = uilabel(app.ParametrynowotworuPanel);
            app.tsLabel.HorizontalAlignment = 'right';
            app.tsLabel.Position = [90 10 25 22];
            app.tsLabel.Text = 'ts';

            % Create tsField
            app.tsField = uieditfield(app.ParametrynowotworuPanel, 'numeric');
            app.tsField.Position = [130 10 49 22];
            app.tsField.Value = 60;

            % Create ParametryleczeniaPanel
            app.ParametryleczeniaPanel = uipanel(app.UIFigure);
            app.ParametryleczeniaPanel.Title = 'Parametry leczenia';
            app.ParametryleczeniaPanel.Position = [421 55 212 128];

            % Create eEditFieldLabel
            app.eEditFieldLabel = uilabel(app.ParametryleczeniaPanel);
            app.eEditFieldLabel.HorizontalAlignment = 'right';
            app.eEditFieldLabel.Position = [1 72 25 22];
            app.eEditFieldLabel.Text = 'e';

            % Create eField
            app.eField = uieditfield(app.ParametryleczeniaPanel, 'numeric');
            app.eField.Position = [41 72 49 22];
            app.eField.Value = 1.3;

            % Create clrLabel
            app.clrLabel = uilabel(app.ParametryleczeniaPanel);
            app.clrLabel.HorizontalAlignment = 'right';
            app.clrLabel.Position = [115 72 25 22];
            app.clrLabel.Text = 'clr';

            % Create clrField
            app.clrField = uieditfield(app.ParametryleczeniaPanel, 'numeric');
            app.clrField.Position = [155 72 49 22];
            app.clrField.Value = 10.1;

            % Create DLabel
            app.DLabel = uilabel(app.ParametryleczeniaPanel);
            app.DLabel.HorizontalAlignment = 'right';
            app.DLabel.Position = [1 40 25 22];
            app.DLabel.Text = 'D';

            % Create DField
            app.DField = uieditfield(app.ParametryleczeniaPanel, 'numeric');
            app.DField.Position = [41 40 49 22];
            app.DField.Value = 13.2;

            % Create PocztekLabel
            app.PocztekLabel = uilabel(app.ParametryleczeniaPanel);
            app.PocztekLabel.HorizontalAlignment = 'right';
            app.PocztekLabel.Position = [86 40 55 22];
            app.PocztekLabel.Text = 'Poczÿtek';

            % Create BeginField
            app.BeginField = uieditfield(app.ParametryleczeniaPanel, 'numeric');
            app.BeginField.Position = [155 40 49 22];
            app.BeginField.Value = 20;

            % Create CzstoLabel
            app.CzstoLabel = uilabel(app.ParametryleczeniaPanel);
            app.CzstoLabel.HorizontalAlignment = 'right';
            app.CzstoLabel.Position = [97 9 55 22];
            app.CzstoLabel.Text = 'Czÿstoÿÿ';

            % Create freqField
            app.freqField = uieditfield(app.ParametryleczeniaPanel, 'numeric');
            app.freqField.Position = [155 9 49 22];
            app.freqField.Value = 7;

            % Create ObliczButton
            app.ObliczButton = uibutton(app.UIFigure, 'push');
            app.ObliczButton.ButtonPushedFcn = createCallbackFcn(app, @ObliczButtonPushed, true);
            app.ObliczButton.Position = [470 21 100 22];
            app.ObliczButton.Text = 'Oblicz';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = AplikacjaModelowanie

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
classdef AplikacjaModelowanie < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                   matlab.ui.Figure
        UIAxes                     matlab.ui.control.UIAxes
        RodzajmodeluDropDownLabel  matlab.ui.control.Label
        RodzajmodeluDropDown       matlab.ui.control.DropDown
        ParametryPanel             matlab.ui.container.Panel
        Label                      matlab.ui.control.Label
        lambda1Field               matlab.ui.control.NumericEditField
        Label_2                    matlab.ui.control.Label
        lambda2Field               matlab.ui.control.NumericEditField
        V2Label                    matlab.ui.control.Label
        V2Field                    matlab.ui.control.NumericEditField
        V1EditFieldLabel           matlab.ui.control.Label
        V1Field                    matlab.ui.control.NumericEditField
        b2Label                    matlab.ui.control.Label
        b2Field                    matlab.ui.control.NumericEditField
        b1EditFieldLabel           matlab.ui.control.Label
        b1Field                    matlab.ui.control.NumericEditField
        Label_5                    matlab.ui.control.Label
        alpha21Field               matlab.ui.control.NumericEditField
        Label_7                    matlab.ui.control.Label
        alpha12Field               matlab.ui.control.NumericEditField
        Label_6                    matlab.ui.control.Label
        miField                    matlab.ui.control.NumericEditField
        dEditFieldLabel            matlab.ui.control.Label
        dField                     matlab.ui.control.NumericEditField
        gLabel                     matlab.ui.control.Label
        gField                     matlab.ui.control.NumericEditField
        eEditFieldLabel            matlab.ui.control.Label
        eField                     matlab.ui.control.NumericEditField
        KEditFieldLabel            matlab.ui.control.Label
        KField                     matlab.ui.control.NumericEditField
        ObliczButton               matlab.ui.control.Button
        tsLabel                    matlab.ui.control.Label
        tsField                    matlab.ui.control.NumericEditField
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
        g % Description
        K % Description
        model % Description
        ts % Description
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
            
        end
        
        function [T,dK,dV1,dV2] = ModelHahnfeldtaZKonkurencja(app)
            
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
            
        end
        
        function wynik = RownaniaHahnfeldtaZKonkurencja(t,x,y)
            
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
            app.g = app.gField.Value;
            app.ts = app.tsField.Value;
            app.model = app.RodzajmodeluDropDown.Value;
            app.K = app.KField.Value;
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
            xlabel(app.UIAxes, {'Czas'; ''})
            ylabel(app.UIAxes, 'Y')
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

            % Create ParametryPanel
            app.ParametryPanel = uipanel(app.UIFigure);
            app.ParametryPanel.Title = 'Parametry';
            app.ParametryPanel.Position = [419 107 183 286];

            % Create Label
            app.Label = uilabel(app.ParametryPanel);
            app.Label.HorizontalAlignment = 'right';
            app.Label.Position = [1 237 25 22];
            app.Label.Text = 'l1';

            % Create lambda1Field
            app.lambda1Field = uieditfield(app.ParametryPanel, 'numeric');
            app.lambda1Field.Position = [41 237 49 22];

            % Create Label_2
            app.Label_2 = uilabel(app.ParametryPanel);
            app.Label_2.HorizontalAlignment = 'right';
            app.Label_2.Position = [89 237 25 22];
            app.Label_2.Text = 'l2';

            % Create lambda2Field
            app.lambda2Field = uieditfield(app.ParametryPanel, 'numeric');
            app.lambda2Field.Position = [129 237 49 22];

            % Create V2Label
            app.V2Label = uilabel(app.ParametryPanel);
            app.V2Label.HorizontalAlignment = 'right';
            app.V2Label.Position = [89 207 25 22];
            app.V2Label.Text = 'V2';

            % Create V2Field
            app.V2Field = uieditfield(app.ParametryPanel, 'numeric');
            app.V2Field.Position = [129 207 49 22];

            % Create V1EditFieldLabel
            app.V1EditFieldLabel = uilabel(app.ParametryPanel);
            app.V1EditFieldLabel.HorizontalAlignment = 'right';
            app.V1EditFieldLabel.Position = [1 207 25 22];
            app.V1EditFieldLabel.Text = 'V1';

            % Create V1Field
            app.V1Field = uieditfield(app.ParametryPanel, 'numeric');
            app.V1Field.Position = [41 207 49 22];

            % Create b2Label
            app.b2Label = uilabel(app.ParametryPanel);
            app.b2Label.HorizontalAlignment = 'right';
            app.b2Label.Position = [89 173 25 22];
            app.b2Label.Text = 'b2';

            % Create b2Field
            app.b2Field = uieditfield(app.ParametryPanel, 'numeric');
            app.b2Field.Position = [129 173 49 22];

            % Create b1EditFieldLabel
            app.b1EditFieldLabel = uilabel(app.ParametryPanel);
            app.b1EditFieldLabel.HorizontalAlignment = 'right';
            app.b1EditFieldLabel.Position = [1 173 25 22];
            app.b1EditFieldLabel.Text = 'b1';

            % Create b1Field
            app.b1Field = uieditfield(app.ParametryPanel, 'numeric');
            app.b1Field.Position = [41 173 49 22];

            % Create Label_5
            app.Label_5 = uilabel(app.ParametryPanel);
            app.Label_5.HorizontalAlignment = 'right';
            app.Label_5.Position = [88 142 26 22];
            app.Label_5.Text = 'a21';

            % Create alpha21Field
            app.alpha21Field = uieditfield(app.ParametryPanel, 'numeric');
            app.alpha21Field.Position = [129 142 49 22];

            % Create Label_7
            app.Label_7 = uilabel(app.ParametryPanel);
            app.Label_7.HorizontalAlignment = 'right';
            app.Label_7.Position = [0 142 26 22];
            app.Label_7.Text = 'a12';

            % Create alpha12Field
            app.alpha12Field = uieditfield(app.ParametryPanel, 'numeric');
            app.alpha12Field.Position = [41 142 49 22];

            % Create Label_6
            app.Label_6 = uilabel(app.ParametryPanel);
            app.Label_6.HorizontalAlignment = 'right';
            app.Label_6.Position = [89 106 25 22];
            app.Label_6.Text = 'mi';

            % Create miField
            app.miField = uieditfield(app.ParametryPanel, 'numeric');
            app.miField.Position = [129 106 49 22];

            % Create dEditFieldLabel
            app.dEditFieldLabel = uilabel(app.ParametryPanel);
            app.dEditFieldLabel.HorizontalAlignment = 'right';
            app.dEditFieldLabel.Position = [1 106 25 22];
            app.dEditFieldLabel.Text = 'd';

            % Create dField
            app.dField = uieditfield(app.ParametryPanel, 'numeric');
            app.dField.Position = [41 106 49 22];

            % Create gLabel
            app.gLabel = uilabel(app.ParametryPanel);
            app.gLabel.HorizontalAlignment = 'right';
            app.gLabel.Position = [89 76 25 22];
            app.gLabel.Text = 'g';

            % Create gField
            app.gField = uieditfield(app.ParametryPanel, 'numeric');
            app.gField.Position = [129 76 49 22];

            % Create eEditFieldLabel
            app.eEditFieldLabel = uilabel(app.ParametryPanel);
            app.eEditFieldLabel.HorizontalAlignment = 'right';
            app.eEditFieldLabel.Position = [1 76 25 22];
            app.eEditFieldLabel.Text = 'e';

            % Create eField
            app.eField = uieditfield(app.ParametryPanel, 'numeric');
            app.eField.Position = [41 76 49 22];

            % Create KEditFieldLabel
            app.KEditFieldLabel = uilabel(app.ParametryPanel);
            app.KEditFieldLabel.HorizontalAlignment = 'right';
            app.KEditFieldLabel.Position = [1 46 25 22];
            app.KEditFieldLabel.Text = 'K';

            % Create KField
            app.KField = uieditfield(app.ParametryPanel, 'numeric');
            app.KField.Position = [41 46 49 22];

            % Create ObliczButton
            app.ObliczButton = uibutton(app.ParametryPanel, 'push');
            app.ObliczButton.ButtonPushedFcn = createCallbackFcn(app, @ObliczButtonPushed, true);
            app.ObliczButton.Position = [52 13 100 22];
            app.ObliczButton.Text = 'Oblicz';

            % Create tsLabel
            app.tsLabel = uilabel(app.ParametryPanel);
            app.tsLabel.HorizontalAlignment = 'right';
            app.tsLabel.Position = [90 46 25 22];
            app.tsLabel.Text = 'ts';

            % Create tsField
            app.tsField = uieditfield(app.ParametryPanel, 'numeric');
            app.tsField.Position = [130 46 49 22];

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
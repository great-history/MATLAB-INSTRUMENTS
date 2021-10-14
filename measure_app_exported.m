classdef measure_app_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        TabGroup                        matlab.ui.container.TabGroup
        Lockin_initializeTab            matlab.ui.container.Tab
        lockin1CheckBox                 matlab.ui.control.CheckBox
        lockin2CheckBox                 matlab.ui.control.CheckBox
        lockin3CheckBox                 matlab.ui.control.CheckBox
        lockin_modeEditField            matlab.ui.control.NumericEditField
        lockin_initializeButton         matlab.ui.control.Button
        lockin_resetButton              matlab.ui.control.Button
        lockin_modeDropDownLabel        matlab.ui.control.Label
        lockin_modeDropDown             matlab.ui.control.DropDown
        RsEditFieldLabel                matlab.ui.control.Label
        RsEditField                     matlab.ui.control.NumericEditField
        lockin_nameDropDownLabel        matlab.ui.control.Label
        lockin_nameDropDown             matlab.ui.control.DropDown
        initial_valueEditFieldLabel     matlab.ui.control.Label
        lockin_initial_valueEditField   matlab.ui.control.NumericEditField
        lockin_frequencyEditFieldLabel  matlab.ui.control.Label
        lockin_frequencyEditField       matlab.ui.control.NumericEditField
        sensitivityEditFieldLabel       matlab.ui.control.Label
        sensitivityEditField            matlab.ui.control.NumericEditField
        Gate_initializeTab              matlab.ui.container.Tab
        gate_initializeButton           matlab.ui.control.Button
        gate_resetButton                matlab.ui.control.Button
        gate_nameDropDownLabel          matlab.ui.control.Label
        gate_nameDropDown               matlab.ui.control.DropDown
        initial_valueEditFieldLabel_2   matlab.ui.control.Label
        gate_initial_valueEditField     matlab.ui.control.NumericEditField
        rangeEditFieldLabel             matlab.ui.control.Label
        gate_rangeEditField             matlab.ui.control.NumericEditField
        Mag_initializeTab               matlab.ui.container.Tab
        ToDoListPanel                   matlab.ui.container.Panel
        ToDoListBox                     matlab.ui.control.ListBox
        addButton                       matlab.ui.control.Button
        Switch                          matlab.ui.control.Switch
        messageEditFieldLabel           matlab.ui.control.Label
        lockin_messageEditField         matlab.ui.control.EditField
        MeasurementPanel                matlab.ui.container.Panel
        scan1_selectionDropDownLabel    matlab.ui.control.Label
        scan1_selectionDropDown         matlab.ui.control.DropDown
        scan2_selectionDropDownLabel    matlab.ui.control.Label
        scan2_selectionDropDown         matlab.ui.control.DropDown
        scan1_rangeEditFieldLabel       matlab.ui.control.Label
        scan1_rangeEditField            matlab.ui.control.EditField
        scan2_rangeEditFieldLabel       matlab.ui.control.Label
        scan2_rangeEditField            matlab.ui.control.EditField
        scan1_delayEditFieldLabel       matlab.ui.control.Label
        scan1_delayEditField            matlab.ui.control.NumericEditField
        scan2_delayEditFieldLabel       matlab.ui.control.Label
        scan2_delayEditField            matlab.ui.control.NumericEditField
        scan1_reset_stepEditFieldLabel  matlab.ui.control.Label
        scan1_reset_stepEditField       matlab.ui.control.NumericEditField
        scan2_reset_stepEditFieldLabel  matlab.ui.control.Label
        scan2_reset_stepEditField       matlab.ui.control.NumericEditField
        Plot_ModePanel                  matlab.ui.container.Panel
        x_axisDropDownLabel             matlab.ui.control.Label
        x_axisDropDown                  matlab.ui.control.DropDown
        y_axisDropDownLabel             matlab.ui.control.Label
        y_axisDropDown                  matlab.ui.control.DropDown
        signalDropDownLabel             matlab.ui.control.Label
        signalDropDown                  matlab.ui.control.DropDown
        showButton                      matlab.ui.control.Button
        c_tEditFieldLabel               matlab.ui.control.Label
        c_tEditField                    matlab.ui.control.NumericEditField
        c_bEditFieldLabel               matlab.ui.control.Label
        c_bEditField                    matlab.ui.control.NumericEditField
        x_compEditFieldLabel            matlab.ui.control.Label
        x_compEditField                 matlab.ui.control.NumericEditField
        y_compEditFieldLabel            matlab.ui.control.Label
        y_compEditField                 matlab.ui.control.NumericEditField
        x_maxEditFieldLabel             matlab.ui.control.Label
        x_maxEditField                  matlab.ui.control.NumericEditField
        y_maxEditFieldLabel             matlab.ui.control.Label
        y_maxEditField                  matlab.ui.control.NumericEditField
    end

    methods (Access = private)

        % Button pushed function: addButton
        function addButtonPushed(app, event)
            global test_list
            scan1_cur = app.scan1_selectionDropDown.Value;
            scan1_range_cur = app.scan1_rangeEditField.Value;
            scan1_delay_cur = app.scan1_delayEditField.Value;
            scan1_rest_cur = app.scan1_reset_stepEditField.Value;
            scan2_cur = app.scan2_selectionDropDown.Value;
            scan2_range_cur = app.scan2_rangeEditField.Value;
            scan2_delay_cur = app.scan2_delayEditField.Value;
            scan2_rest_cur = app.scan2_reset_stepEditField.Value;
            
            x_axis_cur = app.x_axisDropDown.Value;
            c_t_cur = app.c_tEditField.Value;
            x_comp_cur = app.x_compEditField.Value;
            x_max_cur = app.x_maxEditField.Value;
            
            y_axis_cur = app.y_axisDropDown.Value;
            c_b_cur = app.c_bEditField.Value;
            y_comp_cur = app.y_compEditField.Value;
            y_max_cur = app.y_maxEditField.Value;
            
            signal_cur = app.signalDropDown.Value;
            
            test_cur = struct('scan1',scan1_cur,'scan2',scan2_cur,...
                'scan1_range',scan1_range_cur,'scan2_range',scan2_range_cur,...
                'scan1_delay',scan1_delay_cur,'scan2_delay',scan2_delay_cur,...
                'scan1_reset',scan1_rest_cur,'scan2_reset',scan2_rest_cur,...
                'x_axis',x_axis_cur,'y_axis',y_axis_cur,'x_comp',x_comp_cur,'y_comp',y_comp_cur,...
                'c_t',c_t_cur,'c_b',c_b_cur,'x_max',x_max_cur,'y_max',y_max_cur,...
                'signal',signal_cur);
                          
            num_cur = length(app.ToDoListBox.Items) + 1;
            str_cur = ['test_' num2str(num_cur)];
            app.ToDoListBox.Items(num_cur) = {str_cur};
            test_list.str_cur = test_cur;
            get(app.ToDoListBox)
        end

        % Value changed function: Switch
        function SwitchValueChanged(app, event)
            value = app.Switch.Value;
            if strcmp(value, 'start')
                if ~strcmp(app.scan1_selectionDropDown.Value,'none') & ~strcmp(app.scan2_selectionDropDown.Value,'none')
                    scan_mode = '2d'
                elseif strcmp(app.scan1_selectionDropDown.Value,'none') & strcmp(app.scan2_selectionDropDown.Value,'none')
                    scan_mode = 'none';
                else
                    scan_mode = '1d';
                end
                message = 'start_scanning';
                app.lockin_messageEditField.Value = message;
                switch scan_mode
                    case '1d'
                        scan1d(app,event);
                    case '2d'
                        scan2d(app,event);
                end
                message = 'end_scanning';
                app.lockin_messageEditField.Value = message;
            elseif strcmp(value, 'stop')
                global stop_check
                stop_check=1;
                message = 'stop_scanning';
                app.lockin_messageEditField.Value = message;
            end
        end

        % Button pushed function: lockin_initializeButton
        function lockin_initializeButtonPushed(app, event)
            scan_Initialize(app,event);
        end

        % Button pushed function: lockin_resetButton
        function lockin_resetButtonPushed(app, event)
            app.lockin_nameDropDown.Value = 'none';
            app.lockin_initial_valueEditField.Value = 0;
            app.lockin_frequencyEditField.Value = 500;
            app.sensitivityEditField.Value = 0;
            app.lockin_modeDropDown.Value = 'dV';
            app.lockin_modeEditField.Value = 0;
            app.RsEditField.Value = 0;
        end

        % Button pushed function: gate_initializeButton
        function gate_initializeButtonPushed(app, event)
            scan_Initialize(app,event);
        end

        % Button pushed function: gate_resetButton
        function gate_resetButtonPushed(app, event)
            app.gate_nameDropDown.Value = 'none';
            app.gate_initial_valueEditField.Value = 0;
            app.gate_rangeEditField.Value = 0;
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure
            app.UIFigure = uifigure;
            app.UIFigure.Position = [100 100 634 424];
            app.UIFigure.Name = 'UI Figure';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 274 442 151];

            % Create Lockin_initializeTab
            app.Lockin_initializeTab = uitab(app.TabGroup);
            app.Lockin_initializeTab.Title = 'Lockin_initialize';

            % Create lockin1CheckBox
            app.lockin1CheckBox = uicheckbox(app.Lockin_initializeTab);
            app.lockin1CheckBox.Text = 'lockin1';
            app.lockin1CheckBox.Position = [8 95 60 22];

            % Create lockin2CheckBox
            app.lockin2CheckBox = uicheckbox(app.Lockin_initializeTab);
            app.lockin2CheckBox.Text = 'lockin2';
            app.lockin2CheckBox.Position = [72 95 60 22];

            % Create lockin3CheckBox
            app.lockin3CheckBox = uicheckbox(app.Lockin_initializeTab);
            app.lockin3CheckBox.Text = 'lockin3';
            app.lockin3CheckBox.Position = [136 95 60 22];

            % Create lockin_modeEditField
            app.lockin_modeEditField = uieditfield(app.Lockin_initializeTab, 'numeric');
            app.lockin_modeEditField.Position = [311 36 121 22];

            % Create lockin_initializeButton
            app.lockin_initializeButton = uibutton(app.Lockin_initializeTab, 'push');
            app.lockin_initializeButton.ButtonPushedFcn = createCallbackFcn(app, @lockin_initializeButtonPushed, true);
            app.lockin_initializeButton.BackgroundColor = [0.9412 0.9412 0.9412];
            app.lockin_initializeButton.Position = [207 95 100 22];
            app.lockin_initializeButton.Text = 'lockin_initialize';

            % Create lockin_resetButton
            app.lockin_resetButton = uibutton(app.Lockin_initializeTab, 'push');
            app.lockin_resetButton.ButtonPushedFcn = createCallbackFcn(app, @lockin_resetButtonPushed, true);
            app.lockin_resetButton.Position = [322 95 100 22];
            app.lockin_resetButton.Text = 'lockin_reset';

            % Create lockin_modeDropDownLabel
            app.lockin_modeDropDownLabel = uilabel(app.Lockin_initializeTab);
            app.lockin_modeDropDownLabel.HorizontalAlignment = 'right';
            app.lockin_modeDropDownLabel.Position = [309 64 73 22];
            app.lockin_modeDropDownLabel.Text = 'lockin_mode';

            % Create lockin_modeDropDown
            app.lockin_modeDropDown = uidropdown(app.Lockin_initializeTab);
            app.lockin_modeDropDown.Items = {'dV', 'dI'};
            app.lockin_modeDropDown.Position = [397 64 38 22];
            app.lockin_modeDropDown.Value = 'dV';

            % Create RsEditFieldLabel
            app.RsEditFieldLabel = uilabel(app.Lockin_initializeTab);
            app.RsEditFieldLabel.HorizontalAlignment = 'right';
            app.RsEditFieldLabel.Position = [215 7 25 22];
            app.RsEditFieldLabel.Text = 'Rs';

            % Create RsEditField
            app.RsEditField = uieditfield(app.Lockin_initializeTab, 'numeric');
            app.RsEditField.Position = [249 7 49 22];

            % Create lockin_nameDropDownLabel
            app.lockin_nameDropDownLabel = uilabel(app.Lockin_initializeTab);
            app.lockin_nameDropDownLabel.HorizontalAlignment = 'right';
            app.lockin_nameDropDownLabel.Position = [8 64 73 22];
            app.lockin_nameDropDownLabel.Text = 'lockin_name';

            % Create lockin_nameDropDown
            app.lockin_nameDropDown = uidropdown(app.Lockin_initializeTab);
            app.lockin_nameDropDown.Items = {'none', 'lockin1', 'lockin2', 'lockin3'};
            app.lockin_nameDropDown.Position = [96 64 100 22];
            app.lockin_nameDropDown.Value = 'none';

            % Create initial_valueEditFieldLabel
            app.initial_valueEditFieldLabel = uilabel(app.Lockin_initializeTab);
            app.initial_valueEditFieldLabel.HorizontalAlignment = 'right';
            app.initial_valueEditFieldLabel.Position = [13 36 68 22];
            app.initial_valueEditFieldLabel.Text = 'initial_value';

            % Create lockin_initial_valueEditField
            app.lockin_initial_valueEditField = uieditfield(app.Lockin_initializeTab, 'numeric');
            app.lockin_initial_valueEditField.Limits = [-10 10];
            app.lockin_initial_valueEditField.Position = [96 36 100 22];

            % Create lockin_frequencyEditFieldLabel
            app.lockin_frequencyEditFieldLabel = uilabel(app.Lockin_initializeTab);
            app.lockin_frequencyEditFieldLabel.HorizontalAlignment = 'right';
            app.lockin_frequencyEditFieldLabel.Position = [-4 7 96 22];
            app.lockin_frequencyEditFieldLabel.Text = 'lockin_frequency';

            % Create lockin_frequencyEditField
            app.lockin_frequencyEditField = uieditfield(app.Lockin_initializeTab, 'numeric');
            app.lockin_frequencyEditField.Limits = [500 1500];
            app.lockin_frequencyEditField.Position = [96 7 100 22];
            app.lockin_frequencyEditField.Value = 500;

            % Create sensitivityEditFieldLabel
            app.sensitivityEditFieldLabel = uilabel(app.Lockin_initializeTab);
            app.sensitivityEditFieldLabel.HorizontalAlignment = 'right';
            app.sensitivityEditFieldLabel.Position = [228 64 58 22];
            app.sensitivityEditFieldLabel.Text = 'sensitivity';

            % Create sensitivityEditField
            app.sensitivityEditField = uieditfield(app.Lockin_initializeTab, 'numeric');
            app.sensitivityEditField.Position = [207 36 100 22];

            % Create Gate_initializeTab
            app.Gate_initializeTab = uitab(app.TabGroup);
            app.Gate_initializeTab.Title = 'Gate_initialize';

            % Create gate_initializeButton
            app.gate_initializeButton = uibutton(app.Gate_initializeTab, 'push');
            app.gate_initializeButton.ButtonPushedFcn = createCallbackFcn(app, @gate_initializeButtonPushed, true);
            app.gate_initializeButton.Position = [208 91 100 22];
            app.gate_initializeButton.Text = 'gate_initialize';

            % Create gate_resetButton
            app.gate_resetButton = uibutton(app.Gate_initializeTab, 'push');
            app.gate_resetButton.ButtonPushedFcn = createCallbackFcn(app, @gate_resetButtonPushed, true);
            app.gate_resetButton.Position = [327 91 100 22];
            app.gate_resetButton.Text = 'gate_reset';

            % Create gate_nameDropDownLabel
            app.gate_nameDropDownLabel = uilabel(app.Gate_initializeTab);
            app.gate_nameDropDownLabel.HorizontalAlignment = 'right';
            app.gate_nameDropDownLabel.Position = [9 91 66 22];
            app.gate_nameDropDownLabel.Text = 'gate_name';

            % Create gate_nameDropDown
            app.gate_nameDropDown = uidropdown(app.Gate_initializeTab);
            app.gate_nameDropDown.Items = {'none', 'GS200_top', 'GS200_bottom'};
            app.gate_nameDropDown.Position = [86 91 100 22];
            app.gate_nameDropDown.Value = 'none';

            % Create initial_valueEditFieldLabel_2
            app.initial_valueEditFieldLabel_2 = uilabel(app.Gate_initializeTab);
            app.initial_valueEditFieldLabel_2.HorizontalAlignment = 'right';
            app.initial_valueEditFieldLabel_2.Position = [7 62 68 22];
            app.initial_valueEditFieldLabel_2.Text = 'initial_value';

            % Create gate_initial_valueEditField
            app.gate_initial_valueEditField = uieditfield(app.Gate_initializeTab, 'numeric');
            app.gate_initial_valueEditField.Position = [86 62 100 22];

            % Create rangeEditFieldLabel
            app.rangeEditFieldLabel = uilabel(app.Gate_initializeTab);
            app.rangeEditFieldLabel.HorizontalAlignment = 'right';
            app.rangeEditFieldLabel.Position = [40 33 36 22];
            app.rangeEditFieldLabel.Text = 'range';

            % Create gate_rangeEditField
            app.gate_rangeEditField = uieditfield(app.Gate_initializeTab, 'numeric');
            app.gate_rangeEditField.Position = [86 33 100 22];

            % Create Mag_initializeTab
            app.Mag_initializeTab = uitab(app.TabGroup);
            app.Mag_initializeTab.Title = 'Mag_initialize';

            % Create ToDoListPanel
            app.ToDoListPanel = uipanel(app.UIFigure);
            app.ToDoListPanel.Title = 'To Do List';
            app.ToDoListPanel.FontWeight = 'bold';
            app.ToDoListPanel.Position = [444 1 191 424];

            % Create ToDoListBox
            app.ToDoListBox = uilistbox(app.ToDoListPanel);
            app.ToDoListBox.Items = {};
            app.ToDoListBox.Position = [9 1 173 326];
            app.ToDoListBox.Value = {};

            % Create addButton
            app.addButton = uibutton(app.ToDoListPanel, 'push');
            app.addButton.ButtonPushedFcn = createCallbackFcn(app, @addButtonPushed, true);
            app.addButton.FontWeight = 'bold';
            app.addButton.Position = [9 377 48 22];
            app.addButton.Text = 'add';

            % Create Switch
            app.Switch = uiswitch(app.ToDoListPanel, 'slider');
            app.Switch.Items = {'start', 'stop'};
            app.Switch.ValueChangedFcn = createCallbackFcn(app, @SwitchValueChanged, true);
            app.Switch.FontWeight = 'bold';
            app.Switch.Position = [111 380 36 16];
            app.Switch.Value = 'stop';

            % Create messageEditFieldLabel
            app.messageEditFieldLabel = uilabel(app.ToDoListPanel);
            app.messageEditFieldLabel.HorizontalAlignment = 'right';
            app.messageEditFieldLabel.FontColor = [1 0 0];
            app.messageEditFieldLabel.Position = [68 350 54 22];
            app.messageEditFieldLabel.Text = 'message';

            % Create lockin_messageEditField
            app.lockin_messageEditField = uieditfield(app.ToDoListPanel, 'text');
            app.lockin_messageEditField.HorizontalAlignment = 'center';
            app.lockin_messageEditField.FontColor = [1 0 0];
            app.lockin_messageEditField.Position = [9 328 173 22];

            % Create MeasurementPanel
            app.MeasurementPanel = uipanel(app.UIFigure);
            app.MeasurementPanel.Title = 'Measurement';
            app.MeasurementPanel.FontWeight = 'bold';
            app.MeasurementPanel.Position = [1 118 442 155];

            % Create scan1_selectionDropDownLabel
            app.scan1_selectionDropDownLabel = uilabel(app.MeasurementPanel);
            app.scan1_selectionDropDownLabel.HorizontalAlignment = 'right';
            app.scan1_selectionDropDownLabel.Position = [12 108 92 22];
            app.scan1_selectionDropDownLabel.Text = 'scan1_selection';

            % Create scan1_selectionDropDown
            app.scan1_selectionDropDown = uidropdown(app.MeasurementPanel);
            app.scan1_selectionDropDown.Items = {'none', 'GS200_top'};
            app.scan1_selectionDropDown.Position = [8 82 100 22];
            app.scan1_selectionDropDown.Value = 'none';

            % Create scan2_selectionDropDownLabel
            app.scan2_selectionDropDownLabel = uilabel(app.MeasurementPanel);
            app.scan2_selectionDropDownLabel.HorizontalAlignment = 'right';
            app.scan2_selectionDropDownLabel.Position = [12 47 92 22];
            app.scan2_selectionDropDownLabel.Text = 'scan2_selection';

            % Create scan2_selectionDropDown
            app.scan2_selectionDropDown = uidropdown(app.MeasurementPanel);
            app.scan2_selectionDropDown.Items = {'none', 'GS200_bottom'};
            app.scan2_selectionDropDown.Position = [8 19 100 22];
            app.scan2_selectionDropDown.Value = 'none';

            % Create scan1_rangeEditFieldLabel
            app.scan1_rangeEditFieldLabel = uilabel(app.MeasurementPanel);
            app.scan1_rangeEditFieldLabel.HorizontalAlignment = 'right';
            app.scan1_rangeEditFieldLabel.Position = [129 108 75 22];
            app.scan1_rangeEditFieldLabel.Text = 'scan1_range';

            % Create scan1_rangeEditField
            app.scan1_rangeEditField = uieditfield(app.MeasurementPanel, 'text');
            app.scan1_rangeEditField.Position = [116 82 100 22];

            % Create scan2_rangeEditFieldLabel
            app.scan2_rangeEditFieldLabel = uilabel(app.MeasurementPanel);
            app.scan2_rangeEditFieldLabel.HorizontalAlignment = 'right';
            app.scan2_rangeEditFieldLabel.Position = [129 47 75 22];
            app.scan2_rangeEditFieldLabel.Text = 'scan2_range';

            % Create scan2_rangeEditField
            app.scan2_rangeEditField = uieditfield(app.MeasurementPanel, 'text');
            app.scan2_rangeEditField.Position = [116 19 100 22];

            % Create scan1_delayEditFieldLabel
            app.scan1_delayEditFieldLabel = uilabel(app.MeasurementPanel);
            app.scan1_delayEditFieldLabel.HorizontalAlignment = 'right';
            app.scan1_delayEditFieldLabel.Position = [239 108 73 22];
            app.scan1_delayEditFieldLabel.Text = 'scan1_delay';

            % Create scan1_delayEditField
            app.scan1_delayEditField = uieditfield(app.MeasurementPanel, 'numeric');
            app.scan1_delayEditField.Position = [223 82 100 22];

            % Create scan2_delayEditFieldLabel
            app.scan2_delayEditFieldLabel = uilabel(app.MeasurementPanel);
            app.scan2_delayEditFieldLabel.HorizontalAlignment = 'right';
            app.scan2_delayEditFieldLabel.Position = [239 47 73 22];
            app.scan2_delayEditFieldLabel.Text = 'scan2_delay';

            % Create scan2_delayEditField
            app.scan2_delayEditField = uieditfield(app.MeasurementPanel, 'numeric');
            app.scan2_delayEditField.Position = [223 19 100 22];

            % Create scan1_reset_stepEditFieldLabel
            app.scan1_reset_stepEditFieldLabel = uilabel(app.MeasurementPanel);
            app.scan1_reset_stepEditFieldLabel.HorizontalAlignment = 'right';
            app.scan1_reset_stepEditFieldLabel.Position = [332 108 100 22];
            app.scan1_reset_stepEditFieldLabel.Text = 'scan1_reset_step';

            % Create scan1_reset_stepEditField
            app.scan1_reset_stepEditField = uieditfield(app.MeasurementPanel, 'numeric');
            app.scan1_reset_stepEditField.Position = [332 82 100 22];

            % Create scan2_reset_stepEditFieldLabel
            app.scan2_reset_stepEditFieldLabel = uilabel(app.MeasurementPanel);
            app.scan2_reset_stepEditFieldLabel.HorizontalAlignment = 'right';
            app.scan2_reset_stepEditFieldLabel.Position = [332 47 100 22];
            app.scan2_reset_stepEditFieldLabel.Text = 'scan2_reset_step';

            % Create scan2_reset_stepEditField
            app.scan2_reset_stepEditField = uieditfield(app.MeasurementPanel, 'numeric');
            app.scan2_reset_stepEditField.Position = [332 19 100 22];

            % Create Plot_ModePanel
            app.Plot_ModePanel = uipanel(app.UIFigure);
            app.Plot_ModePanel.Title = 'Plot_Mode';
            app.Plot_ModePanel.FontWeight = 'bold';
            app.Plot_ModePanel.Position = [1 1 442 116];

            % Create x_axisDropDownLabel
            app.x_axisDropDownLabel = uilabel(app.Plot_ModePanel);
            app.x_axisDropDownLabel.HorizontalAlignment = 'right';
            app.x_axisDropDownLabel.Position = [8 69 40 22];
            app.x_axisDropDownLabel.Text = 'x_axis';

            % Create x_axisDropDown
            app.x_axisDropDown = uidropdown(app.Plot_ModePanel);
            app.x_axisDropDown.Items = {'none', 'n', 'D', 'gate', 'frequency', 'gate_comp'};
            app.x_axisDropDown.Position = [63 69 56 22];
            app.x_axisDropDown.Value = 'none';

            % Create y_axisDropDownLabel
            app.y_axisDropDownLabel = uilabel(app.Plot_ModePanel);
            app.y_axisDropDownLabel.HorizontalAlignment = 'right';
            app.y_axisDropDownLabel.Position = [8 39 40 22];
            app.y_axisDropDownLabel.Text = 'y_axis';

            % Create y_axisDropDown
            app.y_axisDropDown = uidropdown(app.Plot_ModePanel);
            app.y_axisDropDown.Items = {'none', 'n', 'D', 'gate', 'frequency', 'gate_comp'};
            app.y_axisDropDown.Position = [63 39 56 22];
            app.y_axisDropDown.Value = 'none';

            % Create signalDropDownLabel
            app.signalDropDownLabel = uilabel(app.Plot_ModePanel);
            app.signalDropDownLabel.HorizontalAlignment = 'right';
            app.signalDropDownLabel.Position = [8 7 37 22];
            app.signalDropDownLabel.Text = 'signal';

            % Create signalDropDown
            app.signalDropDown = uidropdown(app.Plot_ModePanel);
            app.signalDropDown.Items = {'lockin1_dI/dV_X (2e^2/h)', 'lockin1_dI/dV_R (2e^2/h)', 'lockin2_dI/dV_X (2e^2/h)', 'lockin2_dI/dV_R (2e^2/h)', 'lockin3_dI/dV_X (2e^2/h)', 'lockin3_dI/dV_R (2e^2/h)'};
            app.signalDropDown.Position = [60 7 190 22];
            app.signalDropDown.Value = 'lockin1_dI/dV_X (2e^2/h)';

            % Create showButton
            app.showButton = uibutton(app.Plot_ModePanel, 'push');
            app.showButton.FontWeight = 'bold';
            app.showButton.Position = [257 7 66 22];
            app.showButton.Text = 'show';

            % Create c_tEditFieldLabel
            app.c_tEditFieldLabel = uilabel(app.Plot_ModePanel);
            app.c_tEditFieldLabel.HorizontalAlignment = 'right';
            app.c_tEditFieldLabel.Position = [125 69 25 22];
            app.c_tEditFieldLabel.Text = 'c_t';

            % Create c_tEditField
            app.c_tEditField = uieditfield(app.Plot_ModePanel, 'numeric');
            app.c_tEditField.Position = [157 69 50 22];

            % Create c_bEditFieldLabel
            app.c_bEditFieldLabel = uilabel(app.Plot_ModePanel);
            app.c_bEditFieldLabel.HorizontalAlignment = 'right';
            app.c_bEditFieldLabel.Position = [129 39 25 22];
            app.c_bEditFieldLabel.Text = 'c_b';

            % Create c_bEditField
            app.c_bEditField = uieditfield(app.Plot_ModePanel, 'numeric');
            app.c_bEditField.Position = [157 39 50 22];

            % Create x_compEditFieldLabel
            app.x_compEditFieldLabel = uilabel(app.Plot_ModePanel);
            app.x_compEditFieldLabel.HorizontalAlignment = 'right';
            app.x_compEditFieldLabel.Position = [215 69 48 22];
            app.x_compEditFieldLabel.Text = 'x_comp';

            % Create x_compEditField
            app.x_compEditField = uieditfield(app.Plot_ModePanel, 'numeric');
            app.x_compEditField.Position = [270 69 50 22];

            % Create y_compEditFieldLabel
            app.y_compEditFieldLabel = uilabel(app.Plot_ModePanel);
            app.y_compEditFieldLabel.HorizontalAlignment = 'right';
            app.y_compEditFieldLabel.Position = [215 39 48 22];
            app.y_compEditFieldLabel.Text = 'y_comp';

            % Create y_compEditField
            app.y_compEditField = uieditfield(app.Plot_ModePanel, 'numeric');
            app.y_compEditField.Position = [270 39 50 22];

            % Create x_maxEditFieldLabel
            app.x_maxEditFieldLabel = uilabel(app.Plot_ModePanel);
            app.x_maxEditFieldLabel.HorizontalAlignment = 'right';
            app.x_maxEditFieldLabel.Position = [332 69 41 22];
            app.x_maxEditFieldLabel.Text = 'x_max';

            % Create x_maxEditField
            app.x_maxEditField = uieditfield(app.Plot_ModePanel, 'numeric');
            app.x_maxEditField.Position = [380 69 50 22];

            % Create y_maxEditFieldLabel
            app.y_maxEditFieldLabel = uilabel(app.Plot_ModePanel);
            app.y_maxEditFieldLabel.HorizontalAlignment = 'right';
            app.y_maxEditFieldLabel.Position = [332 39 41 22];
            app.y_maxEditFieldLabel.Text = 'y_max';

            % Create y_maxEditField
            app.y_maxEditField = uieditfield(app.Plot_ModePanel, 'numeric');
            app.y_maxEditField.Position = [380 39 50 22];
        end
    end

    methods (Access = public)

        % Construct app
        function app = measure_app_exported

            % Create and configure components
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
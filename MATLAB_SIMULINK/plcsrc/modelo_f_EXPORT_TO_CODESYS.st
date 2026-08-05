(*
 *
 * File: modelo_f_EXPORT_TO_CODESYS.st
 *
 * IEC 61131-3 Structured Text (ST) code generated for subsystem "modelo_f_EXPORT_TO_CODESYS/TO_CODESYS"
 *
 * Model name                      : modelo_f_EXPORT_TO_CODESYS
 * Model version                   : 4.365
 * Model creator                   : Usuario
 * Model last modified by          : Usuario
 * Model last modified on          : Wed Aug 05 13:10:10 2026
 * Model sample time               : 0s
 * Subsystem name                  : modelo_f_EXPORT_TO_CODESYS/TO_CODESYS
 * Subsystem sample time           : 0.02s
 * Simulink PLC Coder version      : 24.2 (R2024b) 21-Jun-2024
 * ST code generated on            : Wed Aug 05 13:10:49 2026
 *
 * Target IDE selection            : 3S CoDeSys 3.5
 * Test Bench included             : No
 *
 *)
FUNCTION_BLOCK TO_CODESYS
VAR_INPUT
    ssMethodType: SINT;
    P_APN: BOOL;
    FC_izaje_min: BOOL;
    FC_izaje_max: BOOL;
    FC_carro_max: BOOL;
    FC_carro_min: BOOL;
    JS_trolley_cmd: LREAL;
    JS_hoist_cmd: LREAL;
    JS_emgy_cmd: BOOL;
    JS_tlk_cmd: BOOL;
    JS_sway_ctrl_cmd: BOOL;
    theta_l_sensor: LREAL;
    w_l_sensor: LREAL;
    w_tm_estimada: LREAL;
    F_hw_sensor: LREAL;
    x_t_est: LREAL;
    v_t_est: LREAL;
    w_hm_estimada: LREAL;
    y_c0_lidar: LREAL;
    l_h_sensor: LREAL;
    FCE_carro_max: BOOL;
    FCE_carro_min: BOOL;
    FCE_izaje_max: BOOL;
    FCE_izaje_min: BOOL;
    sobrevelocidad_carro: BOOL;
    sobrevelocidad_izaje: BOOL;
    JS_emgy_ack_cmd: BOOL;
    TS_1: BOOL;
    TS_2: BOOL;
    TS_3: BOOL;
    TS_4: BOOL;
    TS_5: BOOL;
    THL_1: BOOL;
    THL_2: BOOL;
    THL_3: BOOL;
    THL_4: BOOL;
    THL_5: BOOL;
END_VAR
VAR_OUTPUT
    state_SISTEMA_ON: BOOL;
    FC_h_max_alarm: BOOL;
    FC_h_min_alarm: BOOL;
    FC_t_max_alarm: BOOL;
    FC_t_min_alarm: BOOL;
    operation_mode: BOOL;
    sway_ctr_gain: LREAL;
    m_est: LREAL;
    trolley_emgy: BOOL;
    hoist_emgy: BOOL;
    x_t_ref: LREAL;
    BRK_t: BOOL;
    BRK_hE: BOOL;
    BRK_h: BOOL;
    sway_ctr_enable: BOOL;
    dl_h_ref: LREAL;
    v_t_ref: LREAL;
    l_h_ref: LREAL;
    TLK: BOOL;
END_VAR
VAR
    b_l_h_sensor: LREAL;
    UnitDelay16_DSTATE: BOOL;
    emgy: BOOL;
    lidar_map: ARRAY [0..9000] OF LREAL;
    l_h_obj: LREAL;
    l_h_safe: LREAL;
    x_t_obj: LREAL;
    m_est_vec_pos: LREAL;
    BRK_h_d: BOOL;
    BRK_t_c: BOOL;
    was_Pickup_And_Place_Loop: USINT;
    is_Pickup_And_Place_Loop: USINT;
    dl_h_ref_d: LREAL;
    v_t_ref_g: LREAL;
    is_BRK_t_Logic: USINT;
    is_BRK_h_Logic: USINT;
    is_Trolley_Min_Logic: USINT;
    is_Trolley_Max_Logic: USINT;
    is_Hoist_Min_Logic: USINT;
    is_Hoist_Max_Logic: USINT;
    loop_initialized: BOOL;
    hoist_stopped: BOOL;
    trolley_stopped_complete: BOOL;
    trolley_stopped: BOOL;
    sway_ctr_enable_i: BOOL;
    l_h_pr: LREAL;
    x_t_pr: LREAL;
    l_h_ref_g: LREAL;
    x_t_ref_j: LREAL;
    dl_h_ref_prev: LREAL;
    v_t_ref_prev: LREAL;
    is_TLK_Logic: USINT;
    is_Sway_Control_Mode: USINT;
    is_Mode: USINT;
    is_Trajectory_Planner: USINT;
    l_h_min: LREAL;
    is_Trolley_Movement_Flags: USINT;
    is_Hoist_Movement_Flags: USINT;
    T_s1: LREAL;
    dl_h_ref_a: LREAL;
    v_t_ref_a: LREAL;
    is_Heartbeat_Generator: USINT;
    temporalCounter_i1_d: PLC_CODER_TIMER;
    is_Emergencies: USINT;
    is_Watchdog: USINT;
    temporalCounter_i1: PLC_CODER_TIMER;
    is_Hoist_Emgy: USINT;
    hoist_solved: BOOL;
    watchdog_fail: BOOL;
    is_Trolley_Emgy: USINT;
    trolley_solved: BOOL;
    temporalCounter_i4: PLC_CODER_TIMER;
    heartbeat_prev: BOOL;
    b_counter: SINT;
    temporalCounter_i3: PLC_CODER_TIMER;
    temporalCounter_i2: PLC_CODER_TIMER;
    is_Overspeed: USINT;
    b_container_pillars: ARRAY [0..18] OF LREAL;
END_VAR
VAR_TEMP
    k: DINT;
    pillar_height: LREAL;
    land_end_element: DINT;
    rtb_VectorConcatenate: ARRAY [0..4] OF BOOL;
    CastToDouble: ARRAY [0..4] OF SINT;
    CastToDouble1: ARRAY [0..4] OF SINT;
    Gain3: LREAL;
    UnitDelay16: BOOL;
    heartbeat: BOOL;
    i: DINT;
    tmp: ARRAY [0..1] OF LREAL;
    JS_hoist_cmd_0: ARRAY [0..1] OF LREAL;
    container_pillars: LREAL;
    temp1: BOOL;
    temp2: BOOL;
    temp3: LREAL;
    temp4: LREAL;
    temp5: LREAL;
END_VAR
CASE ssMethodType OF
    SS_INITIALIZE: 
        (* SystemInitialize for Atomic SubSystem: '<Root>/TO_CODESYS' *)
        (* InitializeConditions for UnitDelay: '<S1>/Unit Delay16' *)
        UnitDelay16_DSTATE := FALSE;
        (* SystemInitialize for Chart: '<S1>/Chart' *)
        temporalCounter_i1_d(timerAction := 1, maxTime := 0);
        v_t_ref_g := 0.0;
        BRK_h_d := FALSE;
        sway_ctr_enable_i := FALSE;
        dl_h_ref_d := 0.0;
        (* End of SystemInitialize for SubSystem: '<Root>/TO_CODESYS' *)
        (* SystemInitialize for Atomic SubSystem: '<Root>/TO_CODESYS' *)
        (* SystemInitialize for Chart: '<S1>/Chart' *)
        FOR i := 0 TO 9000 DO 
            lidar_map[i] := 0.0;
        END_FOR;
        v_t_ref_prev := 0.0;
        x_t_obj := 0.0;
        (* End of SystemInitialize for SubSystem: '<Root>/TO_CODESYS' *)
        (* SystemInitialize for Atomic SubSystem: '<Root>/TO_CODESYS' *)
        (* SystemInitialize for Chart: '<S1>/Chart' *)
        FOR i := 0 TO 18 DO 
            b_container_pillars[i] := 0.0;
        END_FOR;
        l_h_obj := 0.0;
        x_t_ref_j := 0.0;
        trolley_stopped_complete := FALSE;
        trolley_stopped := FALSE;
        l_h_ref_g := 38.0;
        hoist_stopped := FALSE;
        l_h_safe := 13.0;
        dl_h_ref_prev := 0.0;
        T_s1 := 0.02;
        l_h_pr := 0.0;
        x_t_pr := 0.0;
        BRK_t_c := FALSE;
        m_est_vec_pos := 0.0;
        l_h_min := 5.0;
        dl_h_ref_a := 0.0;
        v_t_ref_a := 0.0;
        loop_initialized := FALSE;
        is_Heartbeat_Generator := c_TO_CODESYS_IN_NO_ACTIVE_C;
        is_BRK_t_Logic := c_TO_CODESYS_IN_NO_ACTIVE_C;
        is_BRK_h_Logic := c_TO_CODESYS_IN_NO_ACTIVE_C;
        is_TLK_Logic := c_TO_CODESYS_IN_NO_ACTIVE_C;
        is_Sway_Control_Mode := c_TO_CODESYS_IN_NO_ACTIVE_C;
        is_Trolley_Min_Logic := c_TO_CODESYS_IN_NO_ACTIVE_C;
        is_Trolley_Max_Logic := c_TO_CODESYS_IN_NO_ACTIVE_C;
        is_Hoist_Min_Logic := c_TO_CODESYS_IN_NO_ACTIVE_C;
        is_Hoist_Max_Logic := c_TO_CODESYS_IN_NO_ACTIVE_C;
        is_Mode := c_TO_CODESYS_IN_NO_ACTIVE_C;
        is_Trajectory_Planner := c_TO_CODESYS_IN_NO_ACTIVE_C;
        is_Pickup_And_Place_Loop := c_TO_CODESYS_IN_NO_ACTIVE_C;
        was_Pickup_And_Place_Loop := c_TO_CODESYS_IN_NO_ACTIVE_C;
        is_Trolley_Movement_Flags := c_TO_CODESYS_IN_NO_ACTIVE_C;
        is_Hoist_Movement_Flags := c_TO_CODESYS_IN_NO_ACTIVE_C;
        (* Chart: '<S1>/Chart' incorporates:
         *  Outport: '<Root>/TLK'
         *  Outport: '<Root>/operation_mode'
         *  Outport: '<Root>/sway_ctr_gain' *)
        (* Entry: TO_CODESYS/Chart *)
        (* Entry Internal: TO_CODESYS/Chart *)
        (* Transition: '<S2>:114' *)
        (* Entry Internal 'Nivel_1': '<S2>:108' *)
        (* Transition: '<S2>:302' *)
        (* Entry Internal 'Heartbeat_Generator': '<S2>:312' *)
        (* Transition: '<S2>:241' *)
        temporalCounter_i1_d(timerAction := 1, maxTime := 0);
        is_Heartbeat_Generator := c_TO_CODESYS_IN_Heartbeat_H;
        (* Entry 'Heartbeat_High': '<S2>:240' *)
        (* '<S2>:240:3' heartbeat = true; *)
        (* Entry 'SS_OFF': '<S2>:308' *)
        (* '<S2>:308:3' BRK_h = false; *)
        (* '<S2>:308:4' BRK_t = false; *)
        (* '<S2>:308:5' TLK = false; *)
        TLK := FALSE;
        (* '<S2>:308:6' v_t_ref = 0.0; *)
        v_t_ref_g := 0.0;
        (* '<S2>:308:7' dl_h_ref = 0.0; *)
        dl_h_ref_d := 0.0;
        (* '<S2>:308:8' sway_ctr_enable = false; *)
        (* '<S2>:308:9' FC_t_min_alarm = false; *)
        (* '<S2>:308:10' FC_t_max_alarm = false; *)
        (* '<S2>:308:11' FC_h_min_alarm = false; *)
        (* '<S2>:308:12' FC_h_max_alarm = false; *)
        (* '<S2>:308:13' operation_mode = true; *)
        operation_mode := TRUE;
        (* '<S2>:308:14' sway_ctr_gain = 1; *)
        sway_ctr_gain := 1.0;
        (* End of SystemInitialize for SubSystem: '<Root>/TO_CODESYS' *)
        (* '<S2>:308:15' container_pillars =zeros(1,19); *)
        (* SystemInitialize for Atomic SubSystem: '<Root>/TO_CODESYS' *)
        FOR i := 0 TO 18 DO 
            (* Chart: '<S1>/Chart' *)
            b_container_pillars[i] := 0.0;
        END_FOR;
        (* Chart: '<S1>/Chart' incorporates:
         *  Outport: '<Root>/FC_h_max_alarm'
         *  Outport: '<Root>/FC_h_min_alarm'
         *  Outport: '<Root>/FC_t_max_alarm'
         *  Outport: '<Root>/FC_t_min_alarm'
         *  Outport: '<Root>/m_est'
         *  Outport: '<Root>/state_SISTEMA_ON' *)
        (* '<S2>:308:16' m_est_vec = zeros(1, 500); *)
        (* '<S2>:308:17' m_est = 15000; *)
        m_est := 15000.0;
        (* '<S2>:308:18' trolley_moving = true; *)
        (* '<S2>:308:19' trolley_stopped = false; *)
        (* '<S2>:308:20' trolley_stopped_complete = false; *)
        (* '<S2>:308:21' hoist_moving = true; *)
        (* '<S2>:308:22' hoist_stopped = false; *)
        (* '<S2>:308:23' x_t_obj = x_t_est; *)
        x_t_obj := x_t_est;
        (* '<S2>:308:24' x_t_ref = x_t_obj; *)
        x_t_ref_j := x_t_obj;
        (* '<S2>:308:25' l_h_obj = l_h_sensor; *)
        l_h_obj := b_l_h_sensor;
        (* '<S2>:308:26' l_h_ref = l_h_obj; *)
        l_h_ref_g := l_h_obj;
        (* '<S2>:308:27' state_SISTEMA_ON = false; *)
        state_SISTEMA_ON := FALSE;
        (* Entry Internal 'SS_ON': '<S2>:246' *)
        (* Entry Internal 'BRK_Logic': '<S2>:248' *)
        (* Entry 'BRK_t_Logic': '<S2>:247' *)
        (* Entry Internal 'BRK_t_Logic': '<S2>:247' *)
        (* Transition: '<S2>:250' *)
        is_BRK_t_Logic := TO_CODESYS_IN_BRK_t_Closed;
        (* Entry 'BRK_t_Closed': '<S2>:249' *)
        (* '<S2>:249:3' BRK_t = false; *)
        BRK_t_c := FALSE;
        (* Entry Internal 'BRK_h_Logic': '<S2>:253' *)
        (* Transition: '<S2>:255' *)
        is_BRK_h_Logic := TO_CODESYS_IN_BRK_h_Closed;
        (* Entry 'BRK_h_Closed': '<S2>:256' *)
        (* '<S2>:256:3' BRK_h = false; *)
        BRK_h_d := FALSE;
        (* Entry Internal 'TLK_Logic': '<S2>:261' *)
        (* Transition: '<S2>:263' *)
        is_TLK_Logic := TO_CODESYS_IN_Init;
        (* Entry Internal 'Sway_Control_Mode': '<S2>:266' *)
        (* Transition: '<S2>:270' *)
        is_Sway_Control_Mode := d_TO_CODESYS_IN_Sway_Contro;
        (* Entry 'Sway_Control_ON': '<S2>:267' *)
        (* '<S2>:267:3' sway_ctr_enable = true; *)
        sway_ctr_enable_i := TRUE;
        (* Entry 'Limit_Switch': '<S2>:273' *)
        (* Entry Internal 'Limit_Switch': '<S2>:273' *)
        (* Entry Internal 'Trolley_Min_Logic': '<S2>:278' *)
        (* Transition: '<S2>:281' *)
        is_Trolley_Min_Logic := TO_CODESYS_IN_FC_t_Min_Low;
        (* Entry 'FC_t_Min_Low': '<S2>:276' *)
        (* '<S2>:276:3' FC_t_min_alarm = false; *)
        FC_t_min_alarm := FALSE;
        (* Entry Internal 'Trolley_Max_Logic': '<S2>:285' *)
        (* Transition: '<S2>:280' *)
        is_Trolley_Max_Logic := TO_CODESYS_IN_FC_t_Max_Low;
        (* Entry 'FC_t_Max_Low': '<S2>:277' *)
        (* '<S2>:277:3' FC_t_max_alarm = false; *)
        FC_t_max_alarm := FALSE;
        (* Entry Internal 'Hoist_Min_Logic': '<S2>:282' *)
        (* Transition: '<S2>:296' *)
        is_Hoist_Min_Logic := TO_CODESYS_IN_FC_h_Min_Low;
        (* Entry 'FC_h_Min_Low': '<S2>:290' *)
        (* '<S2>:290:3' FC_h_min_alarm = false; *)
        FC_h_min_alarm := FALSE;
        (* Entry Internal 'Hoist_Max_Logic': '<S2>:292' *)
        (* Transition: '<S2>:294' *)
        is_Hoist_Max_Logic := TO_CODESYS_IN_FC_h_Max_Low;
        (* Entry 'FC_h_Max_Low': '<S2>:288' *)
        (* '<S2>:288:3' FC_h_max_alarm = false; *)
        FC_h_max_alarm := FALSE;
        (* Entry 'Lidar_Map': '<S2>:289' *)
        (* '<S2>:289:3' land_end_element = floor((0 - x_c0_left)/dx_grid_lidar) + 1; *)
        (* '<S2>:289:4' land_end_element = max(1, min(lidar_grid_size, land_end_element)); *)
        (* '<S2>:289:5' for idx = 1:9001 *)
        FOR i := 0 TO 9000 DO 
            (* '<S2>:289:6' if idx >= land_end_element *)
            IF (i + 1) >= 3501 THEN 
                (* '<S2>:289:7' lidar_map(idx) = y_h_min; *)
                lidar_map[i] := TO_CODESYS_y_h_min;
            END_IF;
        END_FOR;
        (* '<S2>:289:10' cc = 0; *)
        (* Entry 'Mode': '<S2>:300' *)
        (* Entry Internal 'Mode': '<S2>:300' *)
        (* Transition: '<S2>:303' *)
        is_Mode := TO_CODESYS_IN_Automatic;
        (* Entry 'Automatic': '<S2>:301' *)
        (* Entry 'Trajectory_Planner': '<S2>:323' *)
        (* Entry Internal 'Trajectory_Planner': '<S2>:323' *)
        (* Transition: '<S2>:325' *)
        is_Trajectory_Planner := d_TO_CODESYS_IN_Line_Scan_R;
        (* Entry 'Line_Scan_Rise': '<S2>:324' *)
        (* '<S2>:324:3' l_h_obj = l_h_safe; *)
        l_h_obj := l_h_safe;
        (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
        (* Entry Internal 'Trolley_Movement_Flags': '<S2>:481' *)
        (* Transition: '<S2>:483' *)
        is_Trolley_Movement_Flags := c_TO_CODESYS_IN_Trolley_Mov;
        (* Entry 'Trolley_Moving': '<S2>:482' *)
        (* '<S2>:482:3' trolley_moving = true; *)
        (* '<S2>:482:4' trolley_stopped = false; *)
        trolley_stopped := FALSE;
        (* '<S2>:482:5' trolley_stopped_complete = false; *)
        trolley_stopped_complete := FALSE;
        (* Entry Internal 'Hoist_Movement_Flags': '<S2>:511' *)
        (* Transition: '<S2>:503' *)
        is_Hoist_Movement_Flags := TO_CODESYS_IN_Hoist_Moving;
        (* Entry 'Hoist_Moving': '<S2>:512' *)
        (* '<S2>:512:3' hoist_moving = true; *)
        (* '<S2>:512:4' hoist_stopped = false; *)
        hoist_stopped := FALSE;
        (* SystemInitialize for Chart: '<S1>/Nivel 0 - Seguridad y Protección' incorporates:
         *  Outport: '<Root>/BRK_h'
         *  Outport: '<Root>/BRK_hE'
         *  Outport: '<Root>/BRK_t'
         *  Outport: '<Root>/dl_h_ref'
         *  Outport: '<Root>/hoist_emgy'
         *  Outport: '<Root>/l_h_ref'
         *  Outport: '<Root>/sway_ctr_enable'
         *  Outport: '<Root>/trolley_emgy'
         *  Outport: '<Root>/v_t_ref'
         *  Outport: '<Root>/x_t_ref' *)
        temporalCounter_i1(timerAction := 1, maxTime := 0);
        temporalCounter_i2(timerAction := 1, maxTime := 0);
        temporalCounter_i3(timerAction := 1, maxTime := 0);
        temporalCounter_i1(timerAction := 1, maxTime := 0);
        temporalCounter_i2(timerAction := 1, maxTime := 0);
        temporalCounter_i3(timerAction := 1, maxTime := 0);
        temporalCounter_i1(timerAction := 1, maxTime := 0);
        temporalCounter_i4(timerAction := 1, maxTime := 0);
        BRK_t := FALSE;
        BRK_hE := FALSE;
        BRK_h := FALSE;
        sway_ctr_enable := FALSE;
        dl_h_ref := 0.0;
        v_t_ref := 0.0;
        trolley_emgy := FALSE;
        hoist_emgy := FALSE;
        x_t_ref := 0.0;
        l_h_ref := 0.0;
        is_Hoist_Emgy := c_TO_CODESYS_IN_NO_ACTIVE_C;
        is_Trolley_Emgy := c_TO_CODESYS_IN_NO_ACTIVE_C;
        is_Overspeed := c_TO_CODESYS_IN_NO_ACTIVE_C;
        is_Watchdog := c_TO_CODESYS_IN_NO_ACTIVE_C;
        (* Chart: '<S1>/Nivel 0 - Seguridad y Protección' *)
        (* Entry: TO_CODESYS/Nivel 0 - Seguridad y Protección *)
        (* Entry Internal: TO_CODESYS/Nivel 0 - Seguridad y Protección *)
        (* Transition: '<S3>:2' *)
        (* Entry 'Safety_Security_Control': '<S3>:1' *)
        (* '<S3>:1:3' emgy = false; *)
        (* '<S3>:1:4' watchdog_fail = false; *)
        watchdog_fail := FALSE;
        (* '<S3>:1:5' heartbeat_prev = false; *)
        (* '<S3>:1:6' hoist_solved = false; *)
        (* '<S3>:1:7' trolley_solved = false; *)
        (* Entry Internal 'Safety_Security_Control': '<S3>:1' *)
        (* Entry Internal 'Emergencies': '<S3>:10' *)
        (* Transition: '<S3>:28' *)
        is_Emergencies := TO_CODESYS_IN_Stand_By;
        (* Entry 'Stand_By': '<S3>:27' *)
        (* '<S3>:27:3' hoist_solved = false; *)
        hoist_solved := FALSE;
        (* '<S3>:27:4' trolley_solved = false; *)
        trolley_solved := FALSE;
        (* '<S3>:27:5' emgy = false; *)
        emgy := FALSE;
        (* Entry 'Watchdog': '<S3>:12' *)
        (* '<S3>:12:3' counter = 0; *)
        b_counter := 0;
        (* '<S3>:12:4' heartbeat_prev = true; *)
        heartbeat_prev := TRUE;
        (* Entry Internal 'Watchdog': '<S3>:12' *)
        (* Transition: '<S3>:14' *)
        temporalCounter_i4(timerAction := 1, maxTime := 0);
        is_Watchdog := TO_CODESYS_IN_Init_et;
        (* End of SystemInitialize for SubSystem: '<Root>/TO_CODESYS' *)
    SS_STEP: 
        (* Outputs for Atomic SubSystem: '<Root>/TO_CODESYS' *)
        (* SignalConversion: '<S1>/ConcatBufferAtVector ConcatenateIn1' *)
        rtb_VectorConcatenate[0] := TS_1;
        (* SignalConversion: '<S1>/ConcatBufferAtVector ConcatenateIn2' *)
        rtb_VectorConcatenate[1] := TS_2;
        (* SignalConversion: '<S1>/ConcatBufferAtVector ConcatenateIn3' *)
        rtb_VectorConcatenate[2] := TS_3;
        (* SignalConversion: '<S1>/ConcatBufferAtVector ConcatenateIn4' *)
        rtb_VectorConcatenate[3] := TS_4;
        (* SignalConversion: '<S1>/ConcatBufferAtVector ConcatenateIn5' *)
        rtb_VectorConcatenate[4] := TS_5;
        (* End of Outputs for SubSystem: '<Root>/TO_CODESYS' *)
        (* Outputs for Atomic SubSystem: '<Root>/TO_CODESYS' *)
        FOR i := 0 TO 4 DO 
            (* DataTypeConversion: '<S1>/Cast To Double' *)
            CastToDouble[i] := BOOL_TO_SINT(rtb_VectorConcatenate[i]);
        END_FOR;
        (* SignalConversion: '<S1>/ConcatBufferAtVector Concatenate1In1' *)
        rtb_VectorConcatenate[0] := THL_1;
        (* SignalConversion: '<S1>/ConcatBufferAtVector Concatenate1In2' *)
        rtb_VectorConcatenate[1] := THL_2;
        (* SignalConversion: '<S1>/ConcatBufferAtVector Concatenate1In3' *)
        rtb_VectorConcatenate[2] := THL_3;
        (* SignalConversion: '<S1>/ConcatBufferAtVector Concatenate1In4' *)
        rtb_VectorConcatenate[3] := THL_4;
        (* SignalConversion: '<S1>/ConcatBufferAtVector Concatenate1In5' *)
        rtb_VectorConcatenate[4] := THL_5;
        (* End of Outputs for SubSystem: '<Root>/TO_CODESYS' *)
        (* Outputs for Atomic SubSystem: '<Root>/TO_CODESYS' *)
        FOR i := 0 TO 4 DO 
            (* DataTypeConversion: '<S1>/Cast To Double1' *)
            CastToDouble1[i] := BOOL_TO_SINT(rtb_VectorConcatenate[i]);
        END_FOR;
        (* Gain: '<S1>/Gain3' *)
        Gain3 := -0.017045454545454544 * w_hm_estimada;
        (* Gain: '<S1>/Gain2' *)
        b_l_h_sensor := -0.017045454545454544 * l_h_sensor;
        (* UnitDelay: '<S1>/Unit Delay16' *)
        UnitDelay16 := UnitDelay16_DSTATE;
        (* Chart: '<S1>/Chart' incorporates:
         *  DataTypeConversion: '<S1>/Cast To Double'
         *  DataTypeConversion: '<S1>/Cast To Double1'
         *  Outport: '<Root>/FC_h_max_alarm'
         *  Outport: '<Root>/FC_h_min_alarm'
         *  Outport: '<Root>/FC_t_max_alarm'
         *  Outport: '<Root>/FC_t_min_alarm'
         *  Outport: '<Root>/TLK'
         *  Outport: '<Root>/m_est'
         *  Outport: '<Root>/operation_mode'
         *  Outport: '<Root>/state_SISTEMA_ON'
         *  Outport: '<Root>/sway_ctr_gain' *)
        (* Gateway: TO_CODESYS/Chart *)
        (* During: TO_CODESYS/Chart *)
        (* During 'Nivel_1': '<S2>:108' *)
        (* During 'Heartbeat_Generator': '<S2>:312' *)
        CASE is_Heartbeat_Generator OF
            c_TO_CODESYS_IN_Heartbeat_H: 
                heartbeat := TRUE;
                (* During 'Heartbeat_High': '<S2>:240' *)
                (* '<S2>:242:1' sf_internal_predicateOutput = after(200, msec); *)
                temporalCounter_i1_d(timerAction := 2, maxTime := 200);
                IF temporalCounter_i1_d.done THEN 
                    (* Transition: '<S2>:242' *)
                    is_Heartbeat_Generator := c_TO_CODESYS_IN_NO_ACTIVE_C;
                    temporalCounter_i1_d(timerAction := 1, maxTime := 0);
                    is_Heartbeat_Generator := TO_CODESYS_IN_Heartbeat_Low;
                    (* Entry 'Heartbeat_Low': '<S2>:313' *)
                    (* '<S2>:313:3' heartbeat = false; *)
                    heartbeat := FALSE;
                END_IF;
            ELSE
                heartbeat := FALSE;
                (* During 'Heartbeat_Low': '<S2>:313' *)
                (* '<S2>:243:1' sf_internal_predicateOutput = after(200, msec); *)
                temporalCounter_i1_d(timerAction := 2, maxTime := 200);
                IF temporalCounter_i1_d.done THEN 
                    (* Transition: '<S2>:243' *)
                    is_Heartbeat_Generator := c_TO_CODESYS_IN_NO_ACTIVE_C;
                    temporalCounter_i1_d(timerAction := 1, maxTime := 0);
                    is_Heartbeat_Generator := c_TO_CODESYS_IN_Heartbeat_H;
                    (* Entry 'Heartbeat_High': '<S2>:240' *)
                    (* '<S2>:240:3' heartbeat = true; *)
                    heartbeat := TRUE;
                END_IF;
        END_CASE;
        (* During 'SS_OFF': '<S2>:308' *)
        (* '<S2>:305:1' sf_internal_predicateOutput = P_APN; *)
        IF P_APN THEN 
            (* Transition: '<S2>:305' *)
            (* Exit Internal 'Nivel_1': '<S2>:108' *)
            (* Exit Internal 'SS_ON': '<S2>:246' *)
            (* Exit Internal 'Hoist_Movement_Flags': '<S2>:511' *)
            is_Hoist_Movement_Flags := c_TO_CODESYS_IN_NO_ACTIVE_C;
            (* Exit Internal 'Trolley_Movement_Flags': '<S2>:481' *)
            is_Trolley_Movement_Flags := c_TO_CODESYS_IN_NO_ACTIVE_C;
            (* Exit Internal 'Trajectory_Planner': '<S2>:323' *)
            CASE is_Trajectory_Planner OF
                c_TO_COD_IN_Pickup_And_Plac: 
                    (* Exit Internal 'Pickup_And_Place_Loop': '<S2>:384' *)
                    CASE is_Pickup_And_Place_Loop OF
                        c_TO_COD_IN_Ship_Placement_: 
                            (* Exit 'Ship_Placement_Manual': '<S2>:579' *)
                            (* '<S2>:579:5' m_est = 15000; *)
                            is_Pickup_And_Place_Loop := c_TO_CODESYS_IN_NO_ACTIVE_C;
                        c_TO_CO_IN_Truck_Placement_: 
                            (* Exit 'Truck_Placement_Manual': '<S2>:630' *)
                            (* '<S2>:630:5' m_est = 15000; *)
                            is_Pickup_And_Place_Loop := c_TO_CODESYS_IN_NO_ACTIVE_C;
                        ELSE
                            (* Exit 'Ship_Pickup_Manual': '<S2>:622' *)
                            (* ...m_est = estimar_masa(m_est_vec); *)
                            (* Exit 'Truck_Pickup_Manual': '<S2>:577' *)
                            (* ... m_est = estimar_masa(m_est_vec); *)
                            is_Pickup_And_Place_Loop := c_TO_CODESYS_IN_NO_ACTIVE_C;
                    END_CASE;
                    (* Exit 'Pickup_And_Place_Loop': '<S2>:384' *)
                    (* '<S2>:384:3' loop_initialized = true; *)
                    loop_initialized := TRUE;
                    is_Trajectory_Planner := c_TO_CODESYS_IN_NO_ACTIVE_C;
                ELSE
                    is_Trajectory_Planner := c_TO_CODESYS_IN_NO_ACTIVE_C;
            END_CASE;
            (* Exit Internal 'Mode': '<S2>:300' *)
            is_Mode := c_TO_CODESYS_IN_NO_ACTIVE_C;
            (* Exit Internal 'Limit_Switch': '<S2>:273' *)
            (* Exit Internal 'Hoist_Max_Logic': '<S2>:292' *)
            is_Hoist_Max_Logic := c_TO_CODESYS_IN_NO_ACTIVE_C;
            (* Exit Internal 'Hoist_Min_Logic': '<S2>:282' *)
            is_Hoist_Min_Logic := c_TO_CODESYS_IN_NO_ACTIVE_C;
            (* Exit Internal 'Trolley_Max_Logic': '<S2>:285' *)
            is_Trolley_Max_Logic := c_TO_CODESYS_IN_NO_ACTIVE_C;
            (* Exit Internal 'Trolley_Min_Logic': '<S2>:278' *)
            is_Trolley_Min_Logic := c_TO_CODESYS_IN_NO_ACTIVE_C;
            (* Exit Internal 'Sway_Control_Mode': '<S2>:266' *)
            is_Sway_Control_Mode := c_TO_CODESYS_IN_NO_ACTIVE_C;
            (* Exit Internal 'TLK_Logic': '<S2>:261' *)
            is_TLK_Logic := c_TO_CODESYS_IN_NO_ACTIVE_C;
            (* Exit Internal 'BRK_Logic': '<S2>:248' *)
            (* Exit Internal 'BRK_h_Logic': '<S2>:253' *)
            is_BRK_h_Logic := c_TO_CODESYS_IN_NO_ACTIVE_C;
            (* Exit Internal 'BRK_t_Logic': '<S2>:247' *)
            is_BRK_t_Logic := c_TO_CODESYS_IN_NO_ACTIVE_C;
            (* Exit 'SS_OFF': '<S2>:308' *)
            (* '<S2>:308:29' state_SISTEMA_ON = true; *)
            (* '<S2>:308:30' x_t_pr = 0; *)
            x_t_pr := 0.0;
            (* '<S2>:308:31' l_h_pr = 0; *)
            l_h_pr := 0.0;
            (* '<S2>:308:32' v_t_ref_a = 0; *)
            v_t_ref_a := 0.0;
            (* '<S2>:308:33' dl_h_ref_a=0; *)
            dl_h_ref_a := 0.0;
            (* Exit Internal 'Heartbeat_Generator': '<S2>:312' *)
            is_Heartbeat_Generator := c_TO_CODESYS_IN_NO_ACTIVE_C;
            (* Entry Internal 'Heartbeat_Generator': '<S2>:312' *)
            (* Transition: '<S2>:241' *)
            temporalCounter_i1_d(timerAction := 1, maxTime := 0);
            is_Heartbeat_Generator := c_TO_CODESYS_IN_Heartbeat_H;
            (* Entry 'Heartbeat_High': '<S2>:240' *)
            (* '<S2>:240:3' heartbeat = true; *)
            heartbeat := TRUE;
            (* Entry 'SS_OFF': '<S2>:308' *)
            (* '<S2>:308:3' BRK_h = false; *)
            (* '<S2>:308:4' BRK_t = false; *)
            (* '<S2>:308:5' TLK = false; *)
            TLK := FALSE;
            (* '<S2>:308:6' v_t_ref = 0.0; *)
            v_t_ref_g := 0.0;
            (* '<S2>:308:7' dl_h_ref = 0.0; *)
            dl_h_ref_d := 0.0;
            (* '<S2>:308:8' sway_ctr_enable = false; *)
            (* '<S2>:308:9' FC_t_min_alarm = false; *)
            (* '<S2>:308:10' FC_t_max_alarm = false; *)
            (* '<S2>:308:11' FC_h_min_alarm = false; *)
            (* '<S2>:308:12' FC_h_max_alarm = false; *)
            (* '<S2>:308:13' operation_mode = true; *)
            operation_mode := TRUE;
            (* '<S2>:308:14' sway_ctr_gain = 1; *)
            sway_ctr_gain := 1.0;
            (* '<S2>:308:15' container_pillars =zeros(1,19); *)
            FOR i := 0 TO 18 DO 
                b_container_pillars[i] := 0.0;
            END_FOR;
            (* '<S2>:308:16' m_est_vec = zeros(1, 500); *)
            (* '<S2>:308:17' m_est = 15000; *)
            m_est := 15000.0;
            (* '<S2>:308:18' trolley_moving = true; *)
            (* '<S2>:308:19' trolley_stopped = false; *)
            (* '<S2>:308:20' trolley_stopped_complete = false; *)
            (* '<S2>:308:21' hoist_moving = true; *)
            (* '<S2>:308:22' hoist_stopped = false; *)
            (* '<S2>:308:23' x_t_obj = x_t_est; *)
            x_t_obj := x_t_est;
            (* '<S2>:308:24' x_t_ref = x_t_obj; *)
            x_t_ref_j := x_t_obj;
            (* '<S2>:308:25' l_h_obj = l_h_sensor; *)
            l_h_obj := b_l_h_sensor;
            (* '<S2>:308:26' l_h_ref = l_h_obj; *)
            l_h_ref_g := l_h_obj;
            (* '<S2>:308:27' state_SISTEMA_ON = false; *)
            state_SISTEMA_ON := FALSE;
            (* Entry Internal 'SS_ON': '<S2>:246' *)
            (* Entry Internal 'BRK_Logic': '<S2>:248' *)
            (* Entry 'BRK_t_Logic': '<S2>:247' *)
            (* Entry Internal 'BRK_t_Logic': '<S2>:247' *)
            (* Transition: '<S2>:250' *)
            is_BRK_t_Logic := TO_CODESYS_IN_BRK_t_Closed;
            (* Entry 'BRK_t_Closed': '<S2>:249' *)
            (* '<S2>:249:3' BRK_t = false; *)
            BRK_t_c := FALSE;
            (* Entry Internal 'BRK_h_Logic': '<S2>:253' *)
            (* Transition: '<S2>:255' *)
            is_BRK_h_Logic := TO_CODESYS_IN_BRK_h_Closed;
            (* Entry 'BRK_h_Closed': '<S2>:256' *)
            (* '<S2>:256:3' BRK_h = false; *)
            BRK_h_d := FALSE;
            (* Entry Internal 'TLK_Logic': '<S2>:261' *)
            (* Transition: '<S2>:263' *)
            is_TLK_Logic := TO_CODESYS_IN_Init;
            (* Entry Internal 'Sway_Control_Mode': '<S2>:266' *)
            (* Transition: '<S2>:270' *)
            is_Sway_Control_Mode := d_TO_CODESYS_IN_Sway_Contro;
            (* Entry 'Sway_Control_ON': '<S2>:267' *)
            (* '<S2>:267:3' sway_ctr_enable = true; *)
            sway_ctr_enable_i := TRUE;
            (* Entry 'Limit_Switch': '<S2>:273' *)
            (* Entry Internal 'Limit_Switch': '<S2>:273' *)
            (* Entry Internal 'Trolley_Min_Logic': '<S2>:278' *)
            (* Transition: '<S2>:281' *)
            is_Trolley_Min_Logic := TO_CODESYS_IN_FC_t_Min_Low;
            (* Entry 'FC_t_Min_Low': '<S2>:276' *)
            (* '<S2>:276:3' FC_t_min_alarm = false; *)
            FC_t_min_alarm := FALSE;
            (* Entry Internal 'Trolley_Max_Logic': '<S2>:285' *)
            (* Transition: '<S2>:280' *)
            is_Trolley_Max_Logic := TO_CODESYS_IN_FC_t_Max_Low;
            (* Entry 'FC_t_Max_Low': '<S2>:277' *)
            (* '<S2>:277:3' FC_t_max_alarm = false; *)
            FC_t_max_alarm := FALSE;
            (* Entry Internal 'Hoist_Min_Logic': '<S2>:282' *)
            (* Transition: '<S2>:296' *)
            is_Hoist_Min_Logic := TO_CODESYS_IN_FC_h_Min_Low;
            (* Entry 'FC_h_Min_Low': '<S2>:290' *)
            (* '<S2>:290:3' FC_h_min_alarm = false; *)
            FC_h_min_alarm := FALSE;
            (* Entry Internal 'Hoist_Max_Logic': '<S2>:292' *)
            (* Transition: '<S2>:294' *)
            is_Hoist_Max_Logic := TO_CODESYS_IN_FC_h_Max_Low;
            (* Entry 'FC_h_Max_Low': '<S2>:288' *)
            (* '<S2>:288:3' FC_h_max_alarm = false; *)
            FC_h_max_alarm := FALSE;
            (* Entry 'Lidar_Map': '<S2>:289' *)
            (* '<S2>:289:3' land_end_element = floor((0 - x_c0_left)/dx_grid_lidar) + 1; *)
            (* '<S2>:289:4' land_end_element = max(1, min(lidar_grid_size, land_end_element)); *)
            (* '<S2>:289:5' for idx = 1:9001 *)
            FOR i := 0 TO 9000 DO 
                (* '<S2>:289:6' if idx >= land_end_element *)
                IF (i + 1) >= 3501 THEN 
                    (* '<S2>:289:7' lidar_map(idx) = y_h_min; *)
                    lidar_map[i] := TO_CODESYS_y_h_min;
                END_IF;
            END_FOR;
            (* '<S2>:289:10' cc = 0; *)
            (* Entry 'Mode': '<S2>:300' *)
            (* Entry Internal 'Mode': '<S2>:300' *)
            (* Transition: '<S2>:303' *)
            is_Mode := TO_CODESYS_IN_Automatic;
            (* Entry 'Automatic': '<S2>:301' *)
            (* Entry 'Trajectory_Planner': '<S2>:323' *)
            (* Entry Internal 'Trajectory_Planner': '<S2>:323' *)
            (* Transition: '<S2>:325' *)
            is_Trajectory_Planner := d_TO_CODESYS_IN_Line_Scan_R;
            (* Entry 'Line_Scan_Rise': '<S2>:324' *)
            (* '<S2>:324:3' l_h_obj = l_h_safe; *)
            l_h_obj := l_h_safe;
            (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
            (* Entry Internal 'Trolley_Movement_Flags': '<S2>:481' *)
            (* Transition: '<S2>:483' *)
            is_Trolley_Movement_Flags := c_TO_CODESYS_IN_Trolley_Mov;
            (* Entry 'Trolley_Moving': '<S2>:482' *)
            (* '<S2>:482:3' trolley_moving = true; *)
            (* '<S2>:482:4' trolley_stopped = false; *)
            trolley_stopped := FALSE;
            (* '<S2>:482:5' trolley_stopped_complete = false; *)
            trolley_stopped_complete := FALSE;
            (* Entry Internal 'Hoist_Movement_Flags': '<S2>:511' *)
            (* Transition: '<S2>:503' *)
            is_Hoist_Movement_Flags := TO_CODESYS_IN_Hoist_Moving;
            (* Entry 'Hoist_Moving': '<S2>:512' *)
            (* '<S2>:512:3' hoist_moving = true; *)
            (* '<S2>:512:4' hoist_stopped = false; *)
            hoist_stopped := FALSE;
        END_IF;
        (* During 'SS_ON': '<S2>:246' *)
        (* '<S2>:309:1' sf_internal_predicateOutput = ~P_APN || emgy || P_E; *)
        IF (( NOT P_APN) OR UnitDelay16) OR JS_emgy_cmd THEN 
            (* Transition: '<S2>:309' *)
            (* Exit Internal 'Nivel_1': '<S2>:108' *)
            (* Exit Internal 'SS_ON': '<S2>:246' *)
            (* Exit Internal 'Hoist_Movement_Flags': '<S2>:511' *)
            is_Hoist_Movement_Flags := c_TO_CODESYS_IN_NO_ACTIVE_C;
            (* Exit Internal 'Trolley_Movement_Flags': '<S2>:481' *)
            is_Trolley_Movement_Flags := c_TO_CODESYS_IN_NO_ACTIVE_C;
            (* Exit Internal 'Trajectory_Planner': '<S2>:323' *)
            CASE is_Trajectory_Planner OF
                c_TO_COD_IN_Pickup_And_Plac: 
                    (* Exit Internal 'Pickup_And_Place_Loop': '<S2>:384' *)
                    CASE is_Pickup_And_Place_Loop OF
                        c_TO_COD_IN_Ship_Placement_: 
                            (* Exit 'Ship_Placement_Manual': '<S2>:579' *)
                            (* '<S2>:579:5' m_est = 15000; *)
                            is_Pickup_And_Place_Loop := c_TO_CODESYS_IN_NO_ACTIVE_C;
                        c_TO_CO_IN_Truck_Placement_: 
                            (* Exit 'Truck_Placement_Manual': '<S2>:630' *)
                            (* '<S2>:630:5' m_est = 15000; *)
                            is_Pickup_And_Place_Loop := c_TO_CODESYS_IN_NO_ACTIVE_C;
                        ELSE
                            (* Exit 'Ship_Pickup_Manual': '<S2>:622' *)
                            (* ...m_est = estimar_masa(m_est_vec); *)
                            (* Exit 'Truck_Pickup_Manual': '<S2>:577' *)
                            (* ... m_est = estimar_masa(m_est_vec); *)
                            is_Pickup_And_Place_Loop := c_TO_CODESYS_IN_NO_ACTIVE_C;
                    END_CASE;
                    (* Exit 'Pickup_And_Place_Loop': '<S2>:384' *)
                    (* '<S2>:384:3' loop_initialized = true; *)
                    loop_initialized := TRUE;
                    is_Trajectory_Planner := c_TO_CODESYS_IN_NO_ACTIVE_C;
                ELSE
                    is_Trajectory_Planner := c_TO_CODESYS_IN_NO_ACTIVE_C;
            END_CASE;
            (* Exit Internal 'Mode': '<S2>:300' *)
            is_Mode := c_TO_CODESYS_IN_NO_ACTIVE_C;
            (* Exit Internal 'Limit_Switch': '<S2>:273' *)
            (* Exit Internal 'Hoist_Max_Logic': '<S2>:292' *)
            is_Hoist_Max_Logic := c_TO_CODESYS_IN_NO_ACTIVE_C;
            (* Exit Internal 'Hoist_Min_Logic': '<S2>:282' *)
            is_Hoist_Min_Logic := c_TO_CODESYS_IN_NO_ACTIVE_C;
            (* Exit Internal 'Trolley_Max_Logic': '<S2>:285' *)
            is_Trolley_Max_Logic := c_TO_CODESYS_IN_NO_ACTIVE_C;
            (* Exit Internal 'Trolley_Min_Logic': '<S2>:278' *)
            is_Trolley_Min_Logic := c_TO_CODESYS_IN_NO_ACTIVE_C;
            (* Exit Internal 'Sway_Control_Mode': '<S2>:266' *)
            is_Sway_Control_Mode := c_TO_CODESYS_IN_NO_ACTIVE_C;
            (* Exit Internal 'TLK_Logic': '<S2>:261' *)
            is_TLK_Logic := c_TO_CODESYS_IN_NO_ACTIVE_C;
            (* Exit Internal 'BRK_Logic': '<S2>:248' *)
            (* Exit Internal 'BRK_h_Logic': '<S2>:253' *)
            is_BRK_h_Logic := c_TO_CODESYS_IN_NO_ACTIVE_C;
            (* Exit Internal 'BRK_t_Logic': '<S2>:247' *)
            is_BRK_t_Logic := c_TO_CODESYS_IN_NO_ACTIVE_C;
            (* Exit 'SS_OFF': '<S2>:308' *)
            (* '<S2>:308:29' state_SISTEMA_ON = true; *)
            (* '<S2>:308:30' x_t_pr = 0; *)
            x_t_pr := 0.0;
            (* '<S2>:308:31' l_h_pr = 0; *)
            l_h_pr := 0.0;
            (* '<S2>:308:32' v_t_ref_a = 0; *)
            v_t_ref_a := 0.0;
            (* '<S2>:308:33' dl_h_ref_a=0; *)
            dl_h_ref_a := 0.0;
            (* Exit Internal 'Heartbeat_Generator': '<S2>:312' *)
            is_Heartbeat_Generator := c_TO_CODESYS_IN_NO_ACTIVE_C;
            (* Entry Internal 'Heartbeat_Generator': '<S2>:312' *)
            (* Transition: '<S2>:241' *)
            temporalCounter_i1_d(timerAction := 1, maxTime := 0);
            is_Heartbeat_Generator := c_TO_CODESYS_IN_Heartbeat_H;
            (* Entry 'Heartbeat_High': '<S2>:240' *)
            (* '<S2>:240:3' heartbeat = true; *)
            heartbeat := TRUE;
            (* Entry 'SS_OFF': '<S2>:308' *)
            (* '<S2>:308:3' BRK_h = false; *)
            (* '<S2>:308:4' BRK_t = false; *)
            (* '<S2>:308:5' TLK = false; *)
            TLK := FALSE;
            (* '<S2>:308:6' v_t_ref = 0.0; *)
            v_t_ref_g := 0.0;
            (* '<S2>:308:7' dl_h_ref = 0.0; *)
            dl_h_ref_d := 0.0;
            (* '<S2>:308:8' sway_ctr_enable = false; *)
            (* '<S2>:308:9' FC_t_min_alarm = false; *)
            (* '<S2>:308:10' FC_t_max_alarm = false; *)
            (* '<S2>:308:11' FC_h_min_alarm = false; *)
            (* '<S2>:308:12' FC_h_max_alarm = false; *)
            (* '<S2>:308:13' operation_mode = true; *)
            operation_mode := TRUE;
            (* '<S2>:308:14' sway_ctr_gain = 1; *)
            sway_ctr_gain := 1.0;
            (* '<S2>:308:15' container_pillars =zeros(1,19); *)
            FOR i := 0 TO 18 DO 
                b_container_pillars[i] := 0.0;
            END_FOR;
            (* '<S2>:308:16' m_est_vec = zeros(1, 500); *)
            (* '<S2>:308:17' m_est = 15000; *)
            m_est := 15000.0;
            (* '<S2>:308:18' trolley_moving = true; *)
            (* '<S2>:308:19' trolley_stopped = false; *)
            (* '<S2>:308:20' trolley_stopped_complete = false; *)
            (* '<S2>:308:21' hoist_moving = true; *)
            (* '<S2>:308:22' hoist_stopped = false; *)
            (* '<S2>:308:23' x_t_obj = x_t_est; *)
            x_t_obj := x_t_est;
            (* '<S2>:308:24' x_t_ref = x_t_obj; *)
            x_t_ref_j := x_t_obj;
            (* '<S2>:308:25' l_h_obj = l_h_sensor; *)
            l_h_obj := b_l_h_sensor;
            (* '<S2>:308:26' l_h_ref = l_h_obj; *)
            l_h_ref_g := l_h_obj;
            (* '<S2>:308:27' state_SISTEMA_ON = false; *)
            state_SISTEMA_ON := FALSE;
            (* Entry Internal 'SS_ON': '<S2>:246' *)
            (* Entry Internal 'BRK_Logic': '<S2>:248' *)
            (* Entry 'BRK_t_Logic': '<S2>:247' *)
            (* Entry Internal 'BRK_t_Logic': '<S2>:247' *)
            (* Transition: '<S2>:250' *)
            is_BRK_t_Logic := TO_CODESYS_IN_BRK_t_Closed;
            (* Entry 'BRK_t_Closed': '<S2>:249' *)
            (* '<S2>:249:3' BRK_t = false; *)
            BRK_t_c := FALSE;
            (* Entry Internal 'BRK_h_Logic': '<S2>:253' *)
            (* Transition: '<S2>:255' *)
            is_BRK_h_Logic := TO_CODESYS_IN_BRK_h_Closed;
            (* Entry 'BRK_h_Closed': '<S2>:256' *)
            (* '<S2>:256:3' BRK_h = false; *)
            BRK_h_d := FALSE;
            (* Entry Internal 'TLK_Logic': '<S2>:261' *)
            (* Transition: '<S2>:263' *)
            is_TLK_Logic := TO_CODESYS_IN_Init;
            (* Entry Internal 'Sway_Control_Mode': '<S2>:266' *)
            (* Transition: '<S2>:270' *)
            is_Sway_Control_Mode := d_TO_CODESYS_IN_Sway_Contro;
            (* Entry 'Sway_Control_ON': '<S2>:267' *)
            (* '<S2>:267:3' sway_ctr_enable = true; *)
            sway_ctr_enable_i := TRUE;
            (* Entry 'Limit_Switch': '<S2>:273' *)
            (* Entry Internal 'Limit_Switch': '<S2>:273' *)
            (* Entry Internal 'Trolley_Min_Logic': '<S2>:278' *)
            (* Transition: '<S2>:281' *)
            is_Trolley_Min_Logic := TO_CODESYS_IN_FC_t_Min_Low;
            (* Entry 'FC_t_Min_Low': '<S2>:276' *)
            (* '<S2>:276:3' FC_t_min_alarm = false; *)
            FC_t_min_alarm := FALSE;
            (* Entry Internal 'Trolley_Max_Logic': '<S2>:285' *)
            (* Transition: '<S2>:280' *)
            is_Trolley_Max_Logic := TO_CODESYS_IN_FC_t_Max_Low;
            (* Entry 'FC_t_Max_Low': '<S2>:277' *)
            (* '<S2>:277:3' FC_t_max_alarm = false; *)
            FC_t_max_alarm := FALSE;
            (* Entry Internal 'Hoist_Min_Logic': '<S2>:282' *)
            (* Transition: '<S2>:296' *)
            is_Hoist_Min_Logic := TO_CODESYS_IN_FC_h_Min_Low;
            (* Entry 'FC_h_Min_Low': '<S2>:290' *)
            (* '<S2>:290:3' FC_h_min_alarm = false; *)
            FC_h_min_alarm := FALSE;
            (* Entry Internal 'Hoist_Max_Logic': '<S2>:292' *)
            (* Transition: '<S2>:294' *)
            is_Hoist_Max_Logic := TO_CODESYS_IN_FC_h_Max_Low;
            (* Entry 'FC_h_Max_Low': '<S2>:288' *)
            (* '<S2>:288:3' FC_h_max_alarm = false; *)
            FC_h_max_alarm := FALSE;
            (* Entry 'Lidar_Map': '<S2>:289' *)
            (* '<S2>:289:3' land_end_element = floor((0 - x_c0_left)/dx_grid_lidar) + 1; *)
            (* '<S2>:289:4' land_end_element = max(1, min(lidar_grid_size, land_end_element)); *)
            (* '<S2>:289:5' for idx = 1:9001 *)
            FOR i := 0 TO 9000 DO 
                (* '<S2>:289:6' if idx >= land_end_element *)
                IF (i + 1) >= 3501 THEN 
                    (* '<S2>:289:7' lidar_map(idx) = y_h_min; *)
                    lidar_map[i] := TO_CODESYS_y_h_min;
                END_IF;
            END_FOR;
            (* '<S2>:289:10' cc = 0; *)
            (* Entry 'Mode': '<S2>:300' *)
            (* Entry Internal 'Mode': '<S2>:300' *)
            (* Transition: '<S2>:303' *)
            is_Mode := TO_CODESYS_IN_Automatic;
            (* Entry 'Automatic': '<S2>:301' *)
            (* Entry 'Trajectory_Planner': '<S2>:323' *)
            (* Entry Internal 'Trajectory_Planner': '<S2>:323' *)
            (* Transition: '<S2>:325' *)
            is_Trajectory_Planner := d_TO_CODESYS_IN_Line_Scan_R;
            (* Entry 'Line_Scan_Rise': '<S2>:324' *)
            (* '<S2>:324:3' l_h_obj = l_h_safe; *)
            l_h_obj := l_h_safe;
            (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
            (* Entry Internal 'Trolley_Movement_Flags': '<S2>:481' *)
            (* Transition: '<S2>:483' *)
            is_Trolley_Movement_Flags := c_TO_CODESYS_IN_Trolley_Mov;
            (* Entry 'Trolley_Moving': '<S2>:482' *)
            (* '<S2>:482:3' trolley_moving = true; *)
            (* '<S2>:482:4' trolley_stopped = false; *)
            trolley_stopped := FALSE;
            (* '<S2>:482:5' trolley_stopped_complete = false; *)
            trolley_stopped_complete := FALSE;
            (* Entry Internal 'Hoist_Movement_Flags': '<S2>:511' *)
            (* Transition: '<S2>:503' *)
            is_Hoist_Movement_Flags := TO_CODESYS_IN_Hoist_Moving;
            (* Entry 'Hoist_Moving': '<S2>:512' *)
            (* '<S2>:512:3' hoist_moving = true; *)
            (* '<S2>:512:4' hoist_stopped = false; *)
            hoist_stopped := FALSE;
        ELSE 
            (* During 'BRK_Logic': '<S2>:248' *)
            (* During 'BRK_t_Logic': '<S2>:247' *)
            CASE is_BRK_t_Logic OF
                TO_CODESYS_IN_BRK_t_Closed: 
                    (* During 'BRK_t_Closed': '<S2>:249' *)
                    (* '<S2>:252:1' sf_internal_predicateOutput =  ~(FC_carro_max && FC_carro_min) && x_t_est < (x_t_max-1.5) && x_t_est > (x_t_min+1.5); *)
                    IF FC_carro_max AND FC_carro_min THEN 
                        UnitDelay16 := TRUE;
                    END_IF;
                    IF (( NOT UnitDelay16) AND (x_t_est < 48.5)) AND (x_t_est > -28.5) THEN 
                        (* Transition: '<S2>:252' *)
                        is_BRK_t_Logic := TO_CODESYS_IN_BRK_t_Opened;
                        (* Entry 'BRK_t_Opened': '<S2>:245' *)
                        (* '<S2>:245:3' BRK_t = true; *)
                        BRK_t_c := TRUE;
                    END_IF;
                ELSE
                    (* During 'BRK_t_Opened': '<S2>:245' *)
                    (* '<S2>:251:1' sf_internal_predicateOutput = (abs(w_tm_estimada) > w_tm_min_BRK) &&  (FC_carro_min || FC_carro_max); *)
                    IF ABS(w_tm_estimada) > 0.01 THEN 
                        IF FC_carro_min OR FC_carro_max THEN 
                            (* Transition: '<S2>:251' *)
                            is_BRK_t_Logic := TO_CODESYS_IN_BRK_t_Closed;
                            (* Entry 'BRK_t_Closed': '<S2>:249' *)
                            (* '<S2>:249:3' BRK_t = false; *)
                            BRK_t_c := FALSE;
                        END_IF;
                    END_IF;
            END_CASE;
            (* During 'BRK_h_Logic': '<S2>:253' *)
            CASE is_BRK_h_Logic OF
                TO_CODESYS_IN_BRK_h_Closed: 
                    (* During 'BRK_h_Closed': '<S2>:256' *)
                    (* '<S2>:260:1' sf_internal_predicateOutput = ~(FC_izaje_max && FC_izaje_min) && l_h_sensor > (l_h_min + 1.5) && l_h_sensor < (l_h_max - 1.5); *)
                    IF FC_izaje_max AND FC_izaje_min THEN 
                        UnitDelay16 := TRUE;
                    ELSE 
                        UnitDelay16 := FALSE;
                    END_IF;
                    IF (( NOT UnitDelay16) AND (b_l_h_sensor > (l_h_min + 1.5))) AND (b_l_h_sensor < 63.5) THEN 
                        (* Transition: '<S2>:260' *)
                        is_BRK_h_Logic := TO_CODESYS_IN_BRK_h_Opened;
                        (* Entry 'BRK_h_Opened': '<S2>:254' *)
                        (* '<S2>:254:3' BRK_h = true; *)
                        BRK_h_d := TRUE;
                    END_IF;
                ELSE
                    (* During 'BRK_h_Opened': '<S2>:254' *)
                    (* '<S2>:257:1' sf_internal_predicateOutput = (abs(w_hm_estimada) > w_hm_min_BRK) && (FC_izaje_min || FC_izaje_max); *)
                    IF ABS(w_hm_estimada) > 0.01 THEN 
                        IF FC_izaje_min OR FC_izaje_max THEN 
                            (* Transition: '<S2>:257' *)
                            is_BRK_h_Logic := TO_CODESYS_IN_BRK_h_Closed;
                            (* Entry 'BRK_h_Closed': '<S2>:256' *)
                            (* '<S2>:256:3' BRK_h = false; *)
                            BRK_h_d := FALSE;
                        END_IF;
                    END_IF;
            END_CASE;
            (* During 'TLK_Logic': '<S2>:261' *)
            CASE is_TLK_Logic OF
                TO_CODESYS_IN_Init: 
                    (* During 'Init': '<S2>:262' *)
                    (* '<S2>:264:1' sf_internal_predicateOutput = TLK; *)
                    IF TLK THEN 
                        (* Transition: '<S2>:264' *)
                        is_TLK_Logic := TO_CODESYS_IN_TLK_Closed;
                        (* Entry 'TLK_Closed': '<S2>:258' *)
                        (* '<S2>:258:3' TLK = true; *)
                    ELSE 
                        (* '<S2>:265:1' sf_internal_predicateOutput = ~TLK; *)
                        (* Transition: '<S2>:265' *)
                        is_TLK_Logic := TO_CODESYS_IN_TLK_Opened;
                        (* Entry 'TLK_Opened': '<S2>:259' *)
                        (* '<S2>:259:3' TLK = false; *)
                    END_IF;
                TO_CODESYS_IN_TLK_Closed: 
                    (* During 'TLK_Closed': '<S2>:258' *)
                    (* '<S2>:269:1' sf_internal_predicateOutput = ~cmd_TLK && abs(F_hw_sensor) <= 0; *)
                    IF  NOT JS_tlk_cmd THEN 
                        IF ABS(F_hw_sensor) <= 0.0 THEN 
                            (* Transition: '<S2>:269' *)
                            is_TLK_Logic := TO_CODESYS_IN_TLK_Opened;
                            (* Entry 'TLK_Opened': '<S2>:259' *)
                            (* '<S2>:259:3' TLK = false; *)
                            TLK := FALSE;
                        END_IF;
                    END_IF;
                ELSE
                    (* During 'TLK_Opened': '<S2>:259' *)
                    (* '<S2>:268:1' sf_internal_predicateOutput = cmd_TLK && abs(F_hw_sensor) <= 0; *)
                    IF JS_tlk_cmd THEN 
                        IF ABS(F_hw_sensor) <= 0.0 THEN 
                            (* Transition: '<S2>:268' *)
                            is_TLK_Logic := TO_CODESYS_IN_TLK_Closed;
                            (* Entry 'TLK_Closed': '<S2>:258' *)
                            (* '<S2>:258:3' TLK = true; *)
                            TLK := TRUE;
                        END_IF;
                    END_IF;
            END_CASE;
            (* During 'Sway_Control_Mode': '<S2>:266' *)
            CASE is_Sway_Control_Mode OF
                c_TO_CODESYS_IN_Sway_Contro: 
                    (* During 'Sway_Control_OFF': '<S2>:272' *)
                    (* '<S2>:271:1' sf_internal_predicateOutput = cmd_sway_ctr && l_h_sensor > 11; *)
                    IF JS_sway_ctrl_cmd AND (b_l_h_sensor > 11.0) THEN 
                        (* Transition: '<S2>:271' *)
                        is_Sway_Control_Mode := d_TO_CODESYS_IN_Sway_Contro;
                        (* Entry 'Sway_Control_ON': '<S2>:267' *)
                        (* '<S2>:267:3' sway_ctr_enable = true; *)
                        sway_ctr_enable_i := TRUE;
                    END_IF;
                ELSE
                    (* During 'Sway_Control_ON': '<S2>:267' *)
                    (* '<S2>:274:1' sf_internal_predicateOutput = ~cmd_sway_ctr || l_h_sensor < 10; *)
                    IF ( NOT JS_sway_ctrl_cmd) OR (b_l_h_sensor < 10.0) THEN 
                        (* Transition: '<S2>:274' *)
                        is_Sway_Control_Mode := c_TO_CODESYS_IN_Sway_Contro;
                        (* Entry 'Sway_Control_OFF': '<S2>:272' *)
                        (* '<S2>:272:3' sway_ctr_enable = false; *)
                        sway_ctr_enable_i := FALSE;
                    END_IF;
            END_CASE;
            (* During 'Limit_Switch': '<S2>:273' *)
            (* During 'Trolley_Min_Logic': '<S2>:278' *)
            CASE is_Trolley_Min_Logic OF
                TO_CODESYS_IN_FC_t_Min_High: 
                    (* During 'FC_t_Min_High': '<S2>:286' *)
                    (* '<S2>:279:1' sf_internal_predicateOutput = ~FC_carro_min; *)
                    IF  NOT FC_carro_min THEN 
                        (* Transition: '<S2>:279' *)
                        is_Trolley_Min_Logic := TO_CODESYS_IN_FC_t_Min_Low;
                        (* Entry 'FC_t_Min_Low': '<S2>:276' *)
                        (* '<S2>:276:3' FC_t_min_alarm = false; *)
                        FC_t_min_alarm := FALSE;
                    END_IF;
                ELSE
                    (* During 'FC_t_Min_Low': '<S2>:276' *)
                    (* '<S2>:275:1' sf_internal_predicateOutput = FC_carro_min; *)
                    IF FC_carro_min THEN 
                        (* Transition: '<S2>:275' *)
                        is_Trolley_Min_Logic := TO_CODESYS_IN_FC_t_Min_High;
                        (* Entry 'FC_t_Min_High': '<S2>:286' *)
                        (* '<S2>:286:3' FC_t_min_alarm = true; *)
                        FC_t_min_alarm := TRUE;
                    END_IF;
            END_CASE;
            (* During 'Trolley_Max_Logic': '<S2>:285' *)
            CASE is_Trolley_Max_Logic OF
                TO_CODESYS_IN_FC_t_Max_High: 
                    (* During 'FC_t_Max_High': '<S2>:284' *)
                    (* '<S2>:287:1' sf_internal_predicateOutput = ~FC_carro_max; *)
                    IF  NOT FC_carro_max THEN 
                        (* Transition: '<S2>:287' *)
                        is_Trolley_Max_Logic := TO_CODESYS_IN_FC_t_Max_Low;
                        (* Entry 'FC_t_Max_Low': '<S2>:277' *)
                        (* '<S2>:277:3' FC_t_max_alarm = false; *)
                        FC_t_max_alarm := FALSE;
                    END_IF;
                ELSE
                    (* During 'FC_t_Max_Low': '<S2>:277' *)
                    (* '<S2>:283:1' sf_internal_predicateOutput = FC_carro_max; *)
                    IF FC_carro_max THEN 
                        (* Transition: '<S2>:283' *)
                        is_Trolley_Max_Logic := TO_CODESYS_IN_FC_t_Max_High;
                        (* Entry 'FC_t_Max_High': '<S2>:284' *)
                        (* '<S2>:284:3' FC_t_max_alarm = true; *)
                        FC_t_max_alarm := TRUE;
                    END_IF;
            END_CASE;
            (* During 'Hoist_Min_Logic': '<S2>:282' *)
            CASE is_Hoist_Min_Logic OF
                TO_CODESYS_IN_FC_h_Min_High: 
                    (* During 'FC_h_Min_High': '<S2>:295' *)
                    (* '<S2>:291:1' sf_internal_predicateOutput = ~FC_izaje_min; *)
                    IF  NOT FC_izaje_min THEN 
                        (* Transition: '<S2>:291' *)
                        is_Hoist_Min_Logic := TO_CODESYS_IN_FC_h_Min_Low;
                        (* Entry 'FC_h_Min_Low': '<S2>:290' *)
                        (* '<S2>:290:3' FC_h_min_alarm = false; *)
                        FC_h_min_alarm := FALSE;
                    END_IF;
                ELSE
                    (* During 'FC_h_Min_Low': '<S2>:290' *)
                    (* '<S2>:297:1' sf_internal_predicateOutput = FC_izaje_min; *)
                    IF FC_izaje_min THEN 
                        (* Transition: '<S2>:297' *)
                        is_Hoist_Min_Logic := TO_CODESYS_IN_FC_h_Min_High;
                        (* Entry 'FC_h_Min_High': '<S2>:295' *)
                        (* '<S2>:295:3' FC_h_min_alarm = true; *)
                        FC_h_min_alarm := TRUE;
                    END_IF;
            END_CASE;
            (* During 'Hoist_Max_Logic': '<S2>:292' *)
            CASE is_Hoist_Max_Logic OF
                TO_CODESYS_IN_FC_h_Max_High: 
                    (* During 'FC_h_Max_High': '<S2>:293' *)
                    (* '<S2>:299:1' sf_internal_predicateOutput = ~FC_izaje_max; *)
                    IF  NOT FC_izaje_max THEN 
                        (* Transition: '<S2>:299' *)
                        is_Hoist_Max_Logic := TO_CODESYS_IN_FC_h_Max_Low;
                        (* Entry 'FC_h_Max_Low': '<S2>:288' *)
                        (* '<S2>:288:3' FC_h_max_alarm = false; *)
                        FC_h_max_alarm := FALSE;
                    END_IF;
                ELSE
                    (* During 'FC_h_Max_Low': '<S2>:288' *)
                    (* '<S2>:298:1' sf_internal_predicateOutput = FC_izaje_max; *)
                    IF FC_izaje_max THEN 
                        (* Transition: '<S2>:298' *)
                        is_Hoist_Max_Logic := TO_CODESYS_IN_FC_h_Max_High;
                        (* Entry 'FC_h_Max_High': '<S2>:293' *)
                        (* '<S2>:293:3' FC_h_max_alarm = true; *)
                        FC_h_max_alarm := TRUE;
                    END_IF;
            END_CASE;
            (* During 'Lidar_Map': '<S2>:289' *)
            (* '<S2>:289:12' x_lidar = x_t_est + x_lidar_offset; *)
            (* '<S2>:289:13' grid_element = max(1, min(lidar_grid_size, floor((x_lidar-x_c0_left)/dx_grid_lidar) + 1)); *)
            (* '<S2>:289:14' lidar_map(grid_element) = y_c0_lidar; *)
            temp3 := rt_floord(u := ((x_t_est + 3.0) - TO_CODESYS_x_c0_left) / 0.01);
            temp4 := MIN(TO_CODESYS_lidar_grid_size, temp3 + 1.0);
            lidar_map[TRUNC(MAX(1.0, temp4)) - 1] := y_c0_lidar;
            (* '<S2>:289:15' window_idx = round((v_t_max * T_s2) / dx_grid_lidar); *)
            (* '<S2>:289:16' n_pilares = 19; *)
            (* '<S2>:289:17' espaciado = (x_containers_right_lim - x_containers_left_lim) / (n_pilares - 1); *)
            (* '<S2>:289:18' l_h_safe = 45 - max(lidar_map) - 1.5 * H_c; *)
            l_h_safe := (45.0 - maximum(x := lidar_map)) - 3.885;
            (* '<S2>:289:19' for i = 1:n_pilares *)
            FOR land_end_element := 0 TO 18 DO 
                (* '<S2>:289:20' x_lidar_pillar = x_containers_left_lim + (i-1)*espaciado; *)
                (* '<S2>:289:21' grid_element_pillar = max(1, min(lidar_grid_size, floor((x_lidar_pillar - x_c0_left)/dx_grid_lidar) + 1)); *)
                i := TRUNC(rt_floord(u := (((((DINT_TO_LREAL(land_end_element) + 1.0) - 1.0) * 2.6111111111111112) + c_TO_CODESY_x_containers_le) - TO_CODESYS_x_c0_left) / 0.01) + 1.0);
                (* '<S2>:289:22' window_start = max(1, grid_element_pillar - window_idx); *)
                (* '<S2>:289:23' window_end   = min(lidar_grid_size, grid_element_pillar + window_idx); *)
                (* --- REEMPLAZO PARA EVITAR ARREGLO DINAMICO --- *)
                (* '<S2>:289:25' pillar_height = lidar_map(window_start); *)
                pillar_height := lidar_map[i - 9];
                (* '<S2>:289:26' for k = (window_start + 1):window_end *)
                FOR k := 0 TO 15 DO 
                    (* '<S2>:289:27' if lidar_map(k) > pillar_height *)
                    container_pillars := lidar_map[(i + k) - 8];
                    IF container_pillars > pillar_height THEN 
                        (* '<S2>:289:28' pillar_height = lidar_map(k); *)
                        pillar_height := container_pillars;
                    END_IF;
                END_FOR;
                (* ---------------------------------------------- *)
                (* '<S2>:289:32' containers_height = pillar_height - y_h_min; *)
                (* '<S2>:289:33' container_pillars(i) = max(0, ceil(containers_height / H_c - 1e-6)); *)
                temp5 := rt_ceild(u := ((pillar_height - TO_CODESYS_y_h_min) / TO_CODESYS_H_c) - 1.0E-6);
                b_container_pillars[land_end_element] := MAX(0.0, temp5);
            END_FOR;
            (* During 'Mode': '<S2>:300' *)
            CASE is_Mode OF
                TO_CODESYS_IN_Automatic: 
                    (* During 'Automatic': '<S2>:301' *)
                    (* '<S2>:304:1' sf_internal_predicateOutput = ~operation_mode; *)
                    IF  NOT operation_mode THEN 
                        (* Transition: '<S2>:304' *)
                        is_Mode := TO_CODESYS_IN_Manual;
                        (* Entry 'Manual': '<S2>:306' *)
                        (* '<S2>:306:3' v_t_ref_prev = v_t_ref; *)
                        v_t_ref_prev := v_t_ref_g;
                        (* '<S2>:306:4' dl_h_ref_prev = dl_h_ref; *)
                        dl_h_ref_prev := dl_h_ref_d;
                        (* '<S2>:306:5' x_t_ref = x_t_est; *)
                        x_t_ref_j := x_t_est;
                        (* '<S2>:306:6' l_h_ref = l_h_sensor; *)
                        l_h_ref_g := b_l_h_sensor;
                    END_IF;
                ELSE
                    (* During 'Manual': '<S2>:306' *)
                    (* '<S2>:307:1' sf_internal_predicateOutput = operation_mode; *)
                    IF operation_mode THEN 
                        (* Transition: '<S2>:307' *)
                        is_Mode := TO_CODESYS_IN_Automatic;
                        (* Entry 'Automatic': '<S2>:301' *)
                    ELSE 
                        (* ...v_t_ref_a = rate_limiter(JS_trolley_cmd*0.15, v_t_ref_prev, 0, T_s1, m_est); *)
                        (* ...dl_h_ref_a = rate_limiter(JS_hoist_cmd*0.15, dl_h_ref_prev, 1, T_s1, m_est); *)
                        (* '<S2>:306:10' if FC_t_min_alarm *)
                        IF FC_t_min_alarm THEN 
                            (* '<S2>:306:11' v_t_ref = max([0, v_t_ref_a]); *)
                            tmp[0] := 0.0;
                            tmp[1] := v_t_ref_a;
                            v_t_ref_g := maximum_d(x := tmp);
                        ELSIF FC_t_max_alarm THEN 
                            (* '<S2>:306:12' elseif FC_t_max_alarm *)
                            (* '<S2>:306:13' v_t_ref = min([0, v_t_ref_a]); *)
                            tmp[0] := 0.0;
                            tmp[1] := v_t_ref_a;
                            v_t_ref_g := minimum(x := tmp);
                        ELSE 
                            (* '<S2>:306:14' else *)
                            (* '<S2>:306:15' v_t_ref = v_t_ref_a; *)
                            v_t_ref_g := v_t_ref_a;
                        END_IF;
                        (* '<S2>:306:17' if FC_h_min_alarm *)
                        IF FC_h_min_alarm THEN 
                            (* '<S2>:306:18' dl_h_ref = max([0, dl_h_ref_a]); *)
                            tmp[0] := 0.0;
                            tmp[1] := dl_h_ref_a;
                            dl_h_ref_d := maximum_d(x := tmp);
                        ELSIF FC_h_max_alarm THEN 
                            (* '<S2>:306:19' elseif FC_h_max_alarm *)
                            (* '<S2>:306:20' dl_h_ref = min([0, dl_h_ref_a]); *)
                            tmp[0] := 0.0;
                            tmp[1] := dl_h_ref_a;
                            dl_h_ref_d := minimum(x := tmp);
                        ELSE 
                            (* '<S2>:306:21' else *)
                            (* '<S2>:306:22' dl_h_ref = dl_h_ref_a; *)
                            dl_h_ref_d := dl_h_ref_a;
                        END_IF;
                        (* '<S2>:306:24' x_t_ref = x_t_ref + T_s1 * (v_t_ref + v_t_ref_prev)/2; *)
                        x_t_ref_j := (((v_t_ref_g + v_t_ref_prev) * T_s1) / 2.0) + x_t_ref_j;
                        (* '<S2>:306:25' l_h_ref = l_h_ref + T_s1 * (dl_h_ref + dl_h_ref_prev)/2; *)
                        l_h_ref_g := (((dl_h_ref_d + dl_h_ref_prev) * T_s1) / 2.0) + l_h_ref_g;
                        (* '<S2>:306:26' v_t_ref_prev = v_t_ref; *)
                        v_t_ref_prev := v_t_ref_g;
                        (* '<S2>:306:27' dl_h_ref_prev = dl_h_ref; *)
                        dl_h_ref_prev := dl_h_ref_d;
                    END_IF;
            END_CASE;
            (* During 'Trajectory_Planner': '<S2>:323' *)
            CASE is_Trajectory_Planner OF
                c_TO_CODESYS_IN_Line_Scan_M: 
                    (* During 'Line_Scan_Move': '<S2>:561' *)
                    (* '<S2>:562:1' sf_internal_predicateOutput = trolley_stopped; *)
                    IF trolley_stopped THEN 
                        (* Transition: '<S2>:562' *)
                        is_Trajectory_Planner := c_TO_CODESYS_IN_Line_Scan_R;
                        (* Entry 'Line_Scan_Return': '<S2>:326' *)
                        (* '<S2>:326:3' x_t_obj = -29.5; *)
                        x_t_obj := -29.5;
                        (* ...[x_t_ref, v_t_ref, ~, x_t_pr] = generador_trayectoria(t, x_t_est, x_t_obj, v_t_est, 1); *)
                    END_IF;
                c_TO_CODESYS_IN_Line_Scan_R: 
                    (* During 'Line_Scan_Return': '<S2>:326' *)
                    (* '<S2>:375:1' sf_internal_predicateOutput = trolley_stopped && hoist_stopped; *)
                    IF trolley_stopped AND hoist_stopped THEN 
                        (* Transition: '<S2>:375' *)
                        is_Trajectory_Planner := c_TO_CODESYS_IN_Scenario_Se;
                        (* Entry 'Scenario_Selector': '<S2>:374' *)
                        (* '<S2>:374:3' sway_ctr_gain = 1; *)
                        sway_ctr_gain := 1.0;
                    END_IF;
                d_TO_CODESYS_IN_Line_Scan_R: 
                    (* During 'Line_Scan_Rise': '<S2>:324' *)
                    (* '<S2>:328:1' sf_internal_predicateOutput = hoist_stopped || l_h_pr > 0.8; *)
                    IF hoist_stopped OR (l_h_pr > 0.8) THEN 
                        (* Transition: '<S2>:328' *)
                        is_Trajectory_Planner := c_TO_CODESYS_IN_Line_Scan_M;
                        (* Entry 'Line_Scan_Move': '<S2>:561' *)
                        (* '<S2>:561:3' x_t_obj = 49.5; *)
                        x_t_obj := 49.5;
                        (* ...[x_t_ref, v_t_ref, ~, x_t_pr] = generador_trayectoria(t, x_t_est, x_t_obj, v_t_est, 1); *)
                    END_IF;
                c_TO_COD_IN_Pickup_And_Plac: 
                    (* During 'Pickup_And_Place_Loop': '<S2>:384' *)
                    (* '<S2>:639:1' sf_internal_predicateOutput = FC_t_min_alarm || FC_t_max_alarm || FC_h_min_alarm || FC_h_max_alarm; *)
                    IF ((FC_t_min_alarm OR FC_t_max_alarm) OR FC_h_min_alarm) OR FC_h_max_alarm THEN 
                        (* Transition: '<S2>:639' *)
                        (* Exit Internal 'Pickup_And_Place_Loop': '<S2>:384' *)
                        CASE is_Pickup_And_Place_Loop OF
                            c_TO_COD_IN_Ship_Placement_: 
                                (* Exit 'Ship_Placement_Manual': '<S2>:579' *)
                                (* '<S2>:579:5' m_est = 15000; *)
                                m_est := 15000.0;
                                is_Pickup_And_Place_Loop := c_TO_CODESYS_IN_NO_ACTIVE_C;
                            c_TO_CO_IN_Truck_Placement_: 
                                (* Exit 'Truck_Placement_Manual': '<S2>:630' *)
                                (* '<S2>:630:5' m_est = 15000; *)
                                m_est := 15000.0;
                                is_Pickup_And_Place_Loop := c_TO_CODESYS_IN_NO_ACTIVE_C;
                            ELSE
                                (* Exit 'Ship_Pickup_Manual': '<S2>:622' *)
                                (* ...m_est = estimar_masa(m_est_vec); *)
                                (* Exit 'Truck_Pickup_Manual': '<S2>:577' *)
                                (* ... m_est = estimar_masa(m_est_vec); *)
                                is_Pickup_And_Place_Loop := c_TO_CODESYS_IN_NO_ACTIVE_C;
                        END_CASE;
                        (* Exit 'Pickup_And_Place_Loop': '<S2>:384' *)
                        (* '<S2>:384:3' loop_initialized = true; *)
                        loop_initialized := TRUE;
                        is_Trajectory_Planner := c_TO_CODESYS_IN_Scenario_Se;
                        (* Entry 'Scenario_Selector': '<S2>:374' *)
                        (* '<S2>:374:3' sway_ctr_gain = 1; *)
                        sway_ctr_gain := 1.0;
                    ELSE 
                        CASE is_Pickup_And_Place_Loop OF
                            TO_CODESYS_IN_Init: 
                                (* During 'Init': '<S2>:641' *)
                                (* '<S2>:642:1' sf_internal_predicateOutput = ~loop_initialized; *)
                                IF  NOT loop_initialized THEN 
                                    (* Transition: '<S2>:642' *)
                                    is_Pickup_And_Place_Loop := c_TO_CODES_IN_Scenario_Sele;
                                    was_Pickup_And_Place_Loop := c_TO_CODES_IN_Scenario_Sele;
                                ELSE 
                                    (* '<S2>:643:1' sf_internal_predicateOutput = loop_initialized; *)
                                    (* Transition: '<S2>:643' *)
                                    (* Entry Internal 'Pickup_And_Place_Loop': '<S2>:384' *)
                                    CASE was_Pickup_And_Place_Loop OF
                                        TO_CODESYS_IN_Init: 
                                            is_Pickup_And_Place_Loop := TO_CODESYS_IN_Init;
                                            was_Pickup_And_Place_Loop := TO_CODESYS_IN_Init;
                                        c_TO_CODES_IN_Scenario_Sele: 
                                            is_Pickup_And_Place_Loop := c_TO_CODES_IN_Scenario_Sele;
                                            was_Pickup_And_Place_Loop := c_TO_CODES_IN_Scenario_Sele;
                                        c_TO_CO_IN_Ship_Palcement_D: 
                                            is_Pickup_And_Place_Loop := c_TO_CO_IN_Ship_Palcement_D;
                                            was_Pickup_And_Place_Loop := c_TO_CO_IN_Ship_Palcement_D;
                                            (* Entry 'Ship_Palcement_Descend': '<S2>:572' *)
                                            (* '<S2>:572:3' operation_mode = true; *)
                                            operation_mode := TRUE;
                                            (* ...l_h_obj = xpos2ypos(lidar_map, x_t_obj) - placement_safety_margin *)
                                            (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
                                        c_TO_CODES_IN_Ship_Pickup_D: 
                                            is_Pickup_And_Place_Loop := c_TO_CODES_IN_Ship_Pickup_D;
                                            was_Pickup_And_Place_Loop := c_TO_CODES_IN_Ship_Pickup_D;
                                            (* Entry 'Ship_Pickup_Descend': '<S2>:620' *)
                                            (* '<S2>:620:3' operation_mode = true; *)
                                            operation_mode := TRUE;
                                            (* ...l_h_obj = xpos2ypos(lidar_map, x_t_obj) - placement_safety_margin *)
                                            (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
                                        c_TO_CODESY_IN_Ship_Pickup_: 
                                            is_Pickup_And_Place_Loop := c_TO_CODESY_IN_Ship_Pickup_;
                                            was_Pickup_And_Place_Loop := c_TO_CODESY_IN_Ship_Pickup_;
                                            (* Entry 'Ship_Pickup_Manual': '<S2>:622' *)
                                            (* '<S2>:622:3' operation_mode = false; *)
                                            operation_mode := FALSE;
                                            (* '<S2>:622:4' m_est_vec_pos = 1; *)
                                            m_est_vec_pos := 1.0;
                                            (* '<S2>:622:5' m_est_vec(:) = 0; *)
                                        c_TO_CODESYS_IN_Ship_Pickup: 
                                            is_Pickup_And_Place_Loop := c_TO_CODESYS_IN_Ship_Pickup;
                                            was_Pickup_And_Place_Loop := c_TO_CODESYS_IN_Ship_Pickup;
                                            (* Entry 'Ship_Pickup_Move': '<S2>:618' *)
                                            (* '<S2>:618:3' operation_mode = true; *)
                                            operation_mode := TRUE;
                                            (* '<S2>:618:4' max_containers = 0; *)
                                            pillar_height := 0.0;
                                            (* '<S2>:618:5' idx_obj = 1; *)
                                            land_end_element := 1;
                                            (* '<S2>:618:6' for i = 1:19 *)
                                            FOR i := 0 TO 18 DO 
                                                (* '<S2>:618:7' if container_pillars(i) > max_containers *)
                                                container_pillars := b_container_pillars[i];
                                                IF container_pillars > pillar_height THEN 
                                                    (* '<S2>:618:8' max_containers = container_pillars(i); *)
                                                    pillar_height := container_pillars;
                                                    (* '<S2>:618:9' idx_obj = i; *)
                                                    land_end_element := i + 1;
                                                END_IF;
                                            END_FOR;
                                            (* '<S2>:618:12' espaciado = (x_containers_right_lim - x_containers_left_lim) / (19 - 1); *)
                                            (* '<S2>:618:13' x_t_obj = x_containers_left_lim + (idx_obj - 1) * espaciado; *)
                                            x_t_obj := ((DINT_TO_LREAL(land_end_element) - 1.0) * 2.6111111111111112) + c_TO_CODESY_x_containers_le;
                                            (* '<S2>:618:14' x_t_obj *)
                                            (* ...[x_t_ref, v_t_ref, ~, x_t_pr] = generador_trayectoria(t, x_t_est, x_t_obj, v_t_est,1 ); *)
                                        d_TO_CODESYS_IN_Ship_Pickup: 
                                            is_Pickup_And_Place_Loop := d_TO_CODESYS_IN_Ship_Pickup;
                                            was_Pickup_And_Place_Loop := d_TO_CODESYS_IN_Ship_Pickup;
                                            (* Entry 'Ship_Pickup_Raise': '<S2>:436' *)
                                            (* '<S2>:436:3' operation_mode = true; *)
                                            operation_mode := TRUE;
                                            (* '<S2>:436:4' l_h_obj = l_h_safe; *)
                                            l_h_obj := l_h_safe;
                                            (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
                                        c_TO_COD_IN_Ship_Placement_: 
                                            is_Pickup_And_Place_Loop := c_TO_COD_IN_Ship_Placement_;
                                            was_Pickup_And_Place_Loop := c_TO_COD_IN_Ship_Placement_;
                                            (* Entry 'Ship_Placement_Manual': '<S2>:579' *)
                                            (* '<S2>:579:3' operation_mode = false; *)
                                            operation_mode := FALSE;
                                        c_TO_CODES_IN_Ship_Placemen: 
                                            is_Pickup_And_Place_Loop := c_TO_CODES_IN_Ship_Placemen;
                                            was_Pickup_And_Place_Loop := c_TO_CODES_IN_Ship_Placemen;
                                            (* Entry 'Ship_Placement_Move': '<S2>:391' *)
                                            (* '<S2>:391:3' operation_mode = true; *)
                                            operation_mode := TRUE;
                                            (* '<S2>:391:4' min_containers = 999; *)
                                            pillar_height := 999.0;
                                            (* '<S2>:391:5' idx_obj = 1; *)
                                            land_end_element := 1;
                                            (* '<S2>:391:6' for i = 1:19 *)
                                            FOR i := 0 TO 18 DO 
                                                (* '<S2>:391:7' if container_pillars(i) < min_containers *)
                                                container_pillars := b_container_pillars[i];
                                                IF container_pillars < pillar_height THEN 
                                                    (* '<S2>:391:8' min_containers = container_pillars(i); *)
                                                    pillar_height := container_pillars;
                                                    (* '<S2>:391:9' idx_obj = i; *)
                                                    land_end_element := i + 1;
                                                END_IF;
                                            END_FOR;
                                            (* '<S2>:391:12' espaciado = (x_containers_right_lim - x_containers_left_lim) / (19 - 1); *)
                                            (* '<S2>:391:13' x_t_obj = x_containers_left_lim + (idx_obj - 1) * espaciado; *)
                                            x_t_obj := ((DINT_TO_LREAL(land_end_element) - 1.0) * 2.6111111111111112) + c_TO_CODESY_x_containers_le;
                                            (* '<S2>:391:14' x_t_obj *)
                                            (* ...[x_t_ref, v_t_ref, ~, x_t_pr] = generador_trayectoria(t, x_t_est, x_t_obj, v_t_est,1 ); *)
                                        c_TO_CODE_IN_Ship_Placement: 
                                            is_Pickup_And_Place_Loop := c_TO_CODE_IN_Ship_Placement;
                                            was_Pickup_And_Place_Loop := c_TO_CODE_IN_Ship_Placement;
                                            (* Entry 'Ship_Placement_Raise': '<S2>:570' *)
                                            (* '<S2>:570:3' operation_mode = true; *)
                                            operation_mode := TRUE;
                                            (* '<S2>:570:4' l_h_obj = l_h_safe; *)
                                            l_h_obj := l_h_safe;
                                            (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
                                        c_TO_CODE_IN_Truck_Pickup_D: 
                                            is_Pickup_And_Place_Loop := c_TO_CODE_IN_Truck_Pickup_D;
                                            was_Pickup_And_Place_Loop := c_TO_CODE_IN_Truck_Pickup_D;
                                            (* Entry 'Truck_Pickup_Descend': '<S2>:564' *)
                                            (* '<S2>:564:3' operation_mode = true; *)
                                            operation_mode := TRUE;
                                            (* '<S2>:564:4' l_h_obj = 45 - truck_pickup_height - pickup_safety_margin *)
                                            l_h_obj := 38.043;
                                            (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
                                        c_TO_CODES_IN_Truck_Pickup_: 
                                            is_Pickup_And_Place_Loop := c_TO_CODES_IN_Truck_Pickup_;
                                            was_Pickup_And_Place_Loop := c_TO_CODES_IN_Truck_Pickup_;
                                            (* Entry 'Truck_Pickup_Manual': '<S2>:577' *)
                                            (* '<S2>:577:3' operation_mode = false; *)
                                            operation_mode := FALSE;
                                            (* '<S2>:577:4' m_est_vec_pos = 1; *)
                                            m_est_vec_pos := 1.0;
                                            (* '<S2>:577:5' m_est_vec(:) = 0; *)
                                        c_TO_CODESYS_IN_Truck_Picku: 
                                            is_Pickup_And_Place_Loop := c_TO_CODESYS_IN_Truck_Picku;
                                            was_Pickup_And_Place_Loop := c_TO_CODESYS_IN_Truck_Picku;
                                            (* Entry 'Truck_Pickup_Move': '<S2>:388' *)
                                            (* '<S2>:388:3' operation_mode = true; *)
                                            operation_mode := TRUE;
                                            (* '<S2>:388:4' for i = 1:5 *)
                                            FOR land_end_element := 0 TO 4 DO 
                                                (* '<S2>:388:5' if trucks_state(i) == 1 *)
                                                IF CastToDouble[land_end_element] = 1 THEN 
                                                    (* '<S2>:388:6' if trucks_has_load(i) == 1 *)
                                                    IF CastToDouble1[land_end_element] = 1 THEN 
                                                        (* '<S2>:388:7' x_t_obj = -25 + (i-1)*5; *)
                                                        x_t_obj := (((DINT_TO_LREAL(land_end_element) + 1.0) - 1.0) * 5.0) - 25.0;
                                                    END_IF;
                                                END_IF;
                                            END_FOR;
                                            (* '<S2>:388:11' x_t_obj *)
                                            (* ...[x_t_ref, v_t_ref, ~, x_t_pr] = generador_trayectoria(t, x_t_est, x_t_obj, v_t_est, 1); *)
                                        c_TO_CODESY_IN_Truck_Pickup: 
                                            is_Pickup_And_Place_Loop := c_TO_CODESY_IN_Truck_Pickup;
                                            was_Pickup_And_Place_Loop := c_TO_CODESY_IN_Truck_Pickup;
                                            (* Entry 'Truck_Pickup_Raise': '<S2>:566' *)
                                            (* '<S2>:566:3' operation_mode = true; *)
                                            operation_mode := TRUE;
                                            (* '<S2>:566:4' l_h_obj = l_h_safe; *)
                                            l_h_obj := l_h_safe;
                                            (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
                                        c_TO_C_IN_Truck_Placement_D: 
                                            is_Pickup_And_Place_Loop := c_TO_C_IN_Truck_Placement_D;
                                            was_Pickup_And_Place_Loop := c_TO_C_IN_Truck_Placement_D;
                                            (* Entry 'Truck_Placement_Descend': '<S2>:628' *)
                                            (* '<S2>:628:3' operation_mode = true; *)
                                            operation_mode := TRUE;
                                            (* '<S2>:628:4' l_h_obj = 45 - truck_pickup_height - pickup_safety_margin *)
                                            l_h_obj := 38.043;
                                            (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
                                        c_TO_CO_IN_Truck_Placement_: 
                                            is_Pickup_And_Place_Loop := c_TO_CO_IN_Truck_Placement_;
                                            was_Pickup_And_Place_Loop := c_TO_CO_IN_Truck_Placement_;
                                            (* Entry 'Truck_Placement_Manual': '<S2>:630' *)
                                            (* '<S2>:630:3' operation_mode = false; *)
                                            operation_mode := FALSE;
                                        c_TO_CODE_IN_Truck_Placemen: 
                                            is_Pickup_And_Place_Loop := c_TO_CODE_IN_Truck_Placemen;
                                            was_Pickup_And_Place_Loop := c_TO_CODE_IN_Truck_Placemen;
                                            (* Entry 'Truck_Placement_Move': '<S2>:626' *)
                                            (* '<S2>:626:3' operation_mode = true; *)
                                            operation_mode := TRUE;
                                            (* '<S2>:626:4' for i = 1:5 *)
                                            FOR land_end_element := 0 TO 4 DO 
                                                (* '<S2>:626:5' if trucks_state(i) == 1 *)
                                                IF CastToDouble[land_end_element] = 1 THEN 
                                                    (* '<S2>:626:6' if trucks_has_load(i) == 0 *)
                                                    IF CastToDouble1[land_end_element] = 0 THEN 
                                                        (* '<S2>:626:7' x_t_obj = -25 + (i-1)*5; *)
                                                        x_t_obj := (((DINT_TO_LREAL(land_end_element) + 1.0) - 1.0) * 5.0) - 25.0;
                                                    END_IF;
                                                END_IF;
                                            END_FOR;
                                            (* '<S2>:626:11' x_t_obj *)
                                            (* ...[x_t_ref, v_t_ref, ~, x_t_pr] = generador_trayectoria(t, x_t_est, x_t_obj, v_t_est, 1); *)
                                        c_TO_COD_IN_Truck_Placement: 
                                            is_Pickup_And_Place_Loop := c_TO_COD_IN_Truck_Placement;
                                            was_Pickup_And_Place_Loop := c_TO_COD_IN_Truck_Placement;
                                            (* Entry 'Truck_Placement_Raise': '<S2>:624' *)
                                            (* '<S2>:624:3' operation_mode = true; *)
                                            operation_mode := TRUE;
                                            (* '<S2>:624:4' l_h_obj = l_h_safe; *)
                                            l_h_obj := l_h_safe;
                                            (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
                                        ELSE
                                            (* Transition: '<S2>:389' *)
                                            is_Pickup_And_Place_Loop := TO_CODESYS_IN_Init;
                                            was_Pickup_And_Place_Loop := TO_CODESYS_IN_Init;
                                    END_CASE;
                                END_IF;
                            c_TO_CODES_IN_Scenario_Sele: 
                                (* During 'Scenario_Selector': '<S2>:433' *)
                                (* '<S2>:434:1' sf_internal_predicateOutput = escenario == 1 || escenario == 3; *)
                                (* Transition: '<S2>:434' *)
                                is_Pickup_And_Place_Loop := c_TO_CODESY_IN_Truck_Pickup;
                                was_Pickup_And_Place_Loop := c_TO_CODESY_IN_Truck_Pickup;
                                (* Entry 'Truck_Pickup_Raise': '<S2>:566' *)
                                (* '<S2>:566:3' operation_mode = true; *)
                                operation_mode := TRUE;
                                (* '<S2>:566:4' l_h_obj = l_h_safe; *)
                                l_h_obj := l_h_safe;
                                (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
                            c_TO_CO_IN_Ship_Palcement_D: 
                                (* During 'Ship_Palcement_Descend': '<S2>:572' *)
                                (* '<S2>:580:1' sf_internal_predicateOutput = hoist_stopped; *)
                                IF hoist_stopped THEN 
                                    (* Transition: '<S2>:580' *)
                                    is_Pickup_And_Place_Loop := c_TO_COD_IN_Ship_Placement_;
                                    was_Pickup_And_Place_Loop := c_TO_COD_IN_Ship_Placement_;
                                    (* Entry 'Ship_Placement_Manual': '<S2>:579' *)
                                    (* '<S2>:579:3' operation_mode = false; *)
                                    operation_mode := FALSE;
                                END_IF;
                            c_TO_CODES_IN_Ship_Pickup_D: 
                                (* During 'Ship_Pickup_Descend': '<S2>:620' *)
                                (* '<S2>:623:1' sf_internal_predicateOutput = hoist_stopped; *)
                                IF hoist_stopped THEN 
                                    (* Transition: '<S2>:623' *)
                                    is_Pickup_And_Place_Loop := c_TO_CODESY_IN_Ship_Pickup_;
                                    was_Pickup_And_Place_Loop := c_TO_CODESY_IN_Ship_Pickup_;
                                    (* Entry 'Ship_Pickup_Manual': '<S2>:622' *)
                                    (* '<S2>:622:3' operation_mode = false; *)
                                    operation_mode := FALSE;
                                    (* '<S2>:622:4' m_est_vec_pos = 1; *)
                                    m_est_vec_pos := 1.0;
                                    (* '<S2>:622:5' m_est_vec(:) = 0; *)
                                END_IF;
                            c_TO_CODESY_IN_Ship_Pickup_: 
                                (* During 'Ship_Pickup_Manual': '<S2>:622' *)
                                (* '<S2>:625:1' sf_internal_predicateOutput = l_h_sensor <=  l_h_obj-1 && TLK; *)
                                IF (b_l_h_sensor <= (l_h_obj - 1.0)) AND TLK THEN 
                                    (* Transition: '<S2>:625' *)
                                    (* Exit 'Ship_Pickup_Manual': '<S2>:622' *)
                                    (* ...m_est = estimar_masa(m_est_vec); *)
                                    is_Pickup_And_Place_Loop := c_TO_COD_IN_Truck_Placement;
                                    was_Pickup_And_Place_Loop := c_TO_COD_IN_Truck_Placement;
                                    (* Entry 'Truck_Placement_Raise': '<S2>:624' *)
                                    (* '<S2>:624:3' operation_mode = true; *)
                                    operation_mode := TRUE;
                                    (* '<S2>:624:4' l_h_obj = l_h_safe; *)
                                    l_h_obj := l_h_safe;
                                    (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
                                ELSE 
                                    (* '<S2>:622:7' if F_hw_sensor > 8000*g && m_est_vec_pos <= length(m_est_vec(1,:)) *)
                                    IF (F_hw_sensor > 78453.2) AND (m_est_vec_pos <= 500.0) THEN 
                                        (* '<S2>:622:8' m_est_vec(1, m_est_vec_pos) = 2*F_hw_sensor/g; *)
                                        (* '<S2>:622:9' m_est_vec_pos = m_est_vec_pos + 1; *)
                                        m_est_vec_pos := m_est_vec_pos + 1.0;
                                    END_IF;
                                END_IF;
                            c_TO_CODESYS_IN_Ship_Pickup: 
                                (* During 'Ship_Pickup_Move': '<S2>:618' *)
                                (* '<S2>:621:1' sf_internal_predicateOutput = trolley_stopped_complete; *)
                                IF trolley_stopped_complete THEN 
                                    (* Transition: '<S2>:621' *)
                                    is_Pickup_And_Place_Loop := c_TO_CODES_IN_Ship_Pickup_D;
                                    was_Pickup_And_Place_Loop := c_TO_CODES_IN_Ship_Pickup_D;
                                    (* Entry 'Ship_Pickup_Descend': '<S2>:620' *)
                                    (* '<S2>:620:3' operation_mode = true; *)
                                    operation_mode := TRUE;
                                    (* ...l_h_obj = xpos2ypos(lidar_map, x_t_obj) - placement_safety_margin *)
                                    (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
                                END_IF;
                            d_TO_CODESYS_IN_Ship_Pickup: 
                                (* During 'Ship_Pickup_Raise': '<S2>:436' *)
                                (* '<S2>:619:1' sf_internal_predicateOutput = hoist_stopped || l_h_pr > 0.8; *)
                                IF hoist_stopped OR (l_h_pr > 0.8) THEN 
                                    (* Transition: '<S2>:619' *)
                                    is_Pickup_And_Place_Loop := c_TO_CODESYS_IN_Ship_Pickup;
                                    was_Pickup_And_Place_Loop := c_TO_CODESYS_IN_Ship_Pickup;
                                    (* Entry 'Ship_Pickup_Move': '<S2>:618' *)
                                    (* '<S2>:618:3' operation_mode = true; *)
                                    operation_mode := TRUE;
                                    (* '<S2>:618:4' max_containers = 0; *)
                                    pillar_height := 0.0;
                                    (* '<S2>:618:5' idx_obj = 1; *)
                                    land_end_element := 1;
                                    (* '<S2>:618:6' for i = 1:19 *)
                                    FOR i := 0 TO 18 DO 
                                        (* '<S2>:618:7' if container_pillars(i) > max_containers *)
                                        container_pillars := b_container_pillars[i];
                                        IF container_pillars > pillar_height THEN 
                                            (* '<S2>:618:8' max_containers = container_pillars(i); *)
                                            pillar_height := container_pillars;
                                            (* '<S2>:618:9' idx_obj = i; *)
                                            land_end_element := i + 1;
                                        END_IF;
                                    END_FOR;
                                    (* '<S2>:618:12' espaciado = (x_containers_right_lim - x_containers_left_lim) / (19 - 1); *)
                                    (* '<S2>:618:13' x_t_obj = x_containers_left_lim + (idx_obj - 1) * espaciado; *)
                                    x_t_obj := ((DINT_TO_LREAL(land_end_element) - 1.0) * 2.6111111111111112) + c_TO_CODESY_x_containers_le;
                                    (* '<S2>:618:14' x_t_obj *)
                                    (* ...[x_t_ref, v_t_ref, ~, x_t_pr] = generador_trayectoria(t, x_t_est, x_t_obj, v_t_est,1 ); *)
                                END_IF;
                            c_TO_COD_IN_Ship_Placement_: 
                                (* During 'Ship_Placement_Manual': '<S2>:579' *)
                                (* '<S2>:413:1' sf_internal_predicateOutput = (l_h_sensor <=  l_h_obj-1 && ~TLK) && escenario == 1; *)
                                (* '<S2>:634:1' sf_internal_predicateOutput = ([l_h_sensor <=  l_h_obj-1 && ~TLK]) && escenario == 3; *)
                                IF (b_l_h_sensor <= (l_h_obj - 1.0)) AND ( NOT TLK) THEN 
                                    (* Transition: '<S2>:634' *)
                                    (* Exit 'Ship_Placement_Manual': '<S2>:579' *)
                                    (* '<S2>:579:5' m_est = 15000; *)
                                    m_est := 15000.0;
                                    is_Pickup_And_Place_Loop := d_TO_CODESYS_IN_Ship_Pickup;
                                    was_Pickup_And_Place_Loop := d_TO_CODESYS_IN_Ship_Pickup;
                                    (* Entry 'Ship_Pickup_Raise': '<S2>:436' *)
                                    (* '<S2>:436:3' operation_mode = true; *)
                                    operation_mode := TRUE;
                                    (* '<S2>:436:4' l_h_obj = l_h_safe; *)
                                    l_h_obj := l_h_safe;
                                    (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
                                END_IF;
                            c_TO_CODES_IN_Ship_Placemen: 
                                (* During 'Ship_Placement_Move': '<S2>:391' *)
                                (* '<S2>:573:1' sf_internal_predicateOutput = trolley_stopped_complete; *)
                                IF trolley_stopped_complete THEN 
                                    (* Transition: '<S2>:573' *)
                                    is_Pickup_And_Place_Loop := c_TO_CO_IN_Ship_Palcement_D;
                                    was_Pickup_And_Place_Loop := c_TO_CO_IN_Ship_Palcement_D;
                                    (* Entry 'Ship_Palcement_Descend': '<S2>:572' *)
                                    (* '<S2>:572:3' operation_mode = true; *)
                                    operation_mode := TRUE;
                                    (* ...l_h_obj = xpos2ypos(lidar_map, x_t_obj) - placement_safety_margin *)
                                    (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
                                END_IF;
                            c_TO_CODE_IN_Ship_Placement: 
                                (* During 'Ship_Placement_Raise': '<S2>:570' *)
                                (* '<S2>:571:1' sf_internal_predicateOutput = hoist_stopped || l_h_pr > 0.8; *)
                                IF hoist_stopped OR (l_h_pr > 0.8) THEN 
                                    (* Transition: '<S2>:571' *)
                                    is_Pickup_And_Place_Loop := c_TO_CODES_IN_Ship_Placemen;
                                    was_Pickup_And_Place_Loop := c_TO_CODES_IN_Ship_Placemen;
                                    (* Entry 'Ship_Placement_Move': '<S2>:391' *)
                                    (* '<S2>:391:3' operation_mode = true; *)
                                    operation_mode := TRUE;
                                    (* '<S2>:391:4' min_containers = 999; *)
                                    pillar_height := 999.0;
                                    (* '<S2>:391:5' idx_obj = 1; *)
                                    land_end_element := 1;
                                    (* '<S2>:391:6' for i = 1:19 *)
                                    FOR i := 0 TO 18 DO 
                                        (* '<S2>:391:7' if container_pillars(i) < min_containers *)
                                        container_pillars := b_container_pillars[i];
                                        IF container_pillars < pillar_height THEN 
                                            (* '<S2>:391:8' min_containers = container_pillars(i); *)
                                            pillar_height := container_pillars;
                                            (* '<S2>:391:9' idx_obj = i; *)
                                            land_end_element := i + 1;
                                        END_IF;
                                    END_FOR;
                                    (* '<S2>:391:12' espaciado = (x_containers_right_lim - x_containers_left_lim) / (19 - 1); *)
                                    (* '<S2>:391:13' x_t_obj = x_containers_left_lim + (idx_obj - 1) * espaciado; *)
                                    x_t_obj := ((DINT_TO_LREAL(land_end_element) - 1.0) * 2.6111111111111112) + c_TO_CODESY_x_containers_le;
                                    (* '<S2>:391:14' x_t_obj *)
                                    (* ...[x_t_ref, v_t_ref, ~, x_t_pr] = generador_trayectoria(t, x_t_est, x_t_obj, v_t_est,1 ); *)
                                END_IF;
                            c_TO_CODE_IN_Truck_Pickup_D: 
                                (* During 'Truck_Pickup_Descend': '<S2>:564' *)
                                (* '<S2>:565:1' sf_internal_predicateOutput = hoist_stopped && trolley_stopped_complete; *)
                                IF hoist_stopped AND trolley_stopped_complete THEN 
                                    (* Transition: '<S2>:565' *)
                                    is_Pickup_And_Place_Loop := c_TO_CODES_IN_Truck_Pickup_;
                                    was_Pickup_And_Place_Loop := c_TO_CODES_IN_Truck_Pickup_;
                                    (* Entry 'Truck_Pickup_Manual': '<S2>:577' *)
                                    (* '<S2>:577:3' operation_mode = false; *)
                                    operation_mode := FALSE;
                                    (* '<S2>:577:4' m_est_vec_pos = 1; *)
                                    m_est_vec_pos := 1.0;
                                    (* '<S2>:577:5' m_est_vec(:) = 0; *)
                                END_IF;
                            c_TO_CODES_IN_Truck_Pickup_: 
                                (* During 'Truck_Pickup_Manual': '<S2>:577' *)
                                (* '<S2>:578:1' sf_internal_predicateOutput = l_h_sensor <= l_h_obj-1 && TLK; *)
                                IF (b_l_h_sensor <= (l_h_obj - 1.0)) AND TLK THEN 
                                    (* Transition: '<S2>:578' *)
                                    (* Exit 'Truck_Pickup_Manual': '<S2>:577' *)
                                    (* ... m_est = estimar_masa(m_est_vec); *)
                                    is_Pickup_And_Place_Loop := c_TO_CODE_IN_Ship_Placement;
                                    was_Pickup_And_Place_Loop := c_TO_CODE_IN_Ship_Placement;
                                    (* Entry 'Ship_Placement_Raise': '<S2>:570' *)
                                    (* '<S2>:570:3' operation_mode = true; *)
                                    operation_mode := TRUE;
                                    (* '<S2>:570:4' l_h_obj = l_h_safe; *)
                                    l_h_obj := l_h_safe;
                                    (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
                                ELSE 
                                    (* '<S2>:577:7' if F_hw_sensor > 8000*g && m_est_vec_pos <= length(m_est_vec(1,:)) *)
                                    IF (F_hw_sensor > 78453.2) AND (m_est_vec_pos <= 500.0) THEN 
                                        (* '<S2>:577:8' m_est_vec(1, m_est_vec_pos) = 2*F_hw_sensor/g; *)
                                        (* '<S2>:577:9' m_est_vec_pos = m_est_vec_pos + 1; *)
                                        m_est_vec_pos := m_est_vec_pos + 1.0;
                                    END_IF;
                                END_IF;
                            c_TO_CODESYS_IN_Truck_Picku: 
                                (* During 'Truck_Pickup_Move': '<S2>:388' *)
                                (* '<S2>:410:1' sf_internal_predicateOutput = trolley_stopped_complete || x_t_pr > 0.95; *)
                                IF trolley_stopped_complete OR (x_t_pr > 0.95) THEN 
                                    (* Transition: '<S2>:410' *)
                                    is_Pickup_And_Place_Loop := c_TO_CODE_IN_Truck_Pickup_D;
                                    was_Pickup_And_Place_Loop := c_TO_CODE_IN_Truck_Pickup_D;
                                    (* Entry 'Truck_Pickup_Descend': '<S2>:564' *)
                                    (* '<S2>:564:3' operation_mode = true; *)
                                    operation_mode := TRUE;
                                    (* '<S2>:564:4' l_h_obj = 45 - truck_pickup_height - pickup_safety_margin *)
                                    l_h_obj := 38.043;
                                    (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
                                END_IF;
                            c_TO_CODESY_IN_Truck_Pickup: 
                                (* During 'Truck_Pickup_Raise': '<S2>:566' *)
                                (* '<S2>:567:1' sf_internal_predicateOutput = hoist_stopped || l_h_pr > 0.8; *)
                                IF hoist_stopped OR (l_h_pr > 0.8) THEN 
                                    (* Transition: '<S2>:567' *)
                                    is_Pickup_And_Place_Loop := c_TO_CODESYS_IN_Truck_Picku;
                                    was_Pickup_And_Place_Loop := c_TO_CODESYS_IN_Truck_Picku;
                                    (* Entry 'Truck_Pickup_Move': '<S2>:388' *)
                                    (* '<S2>:388:3' operation_mode = true; *)
                                    operation_mode := TRUE;
                                    (* '<S2>:388:4' for i = 1:5 *)
                                    FOR land_end_element := 0 TO 4 DO 
                                        (* '<S2>:388:5' if trucks_state(i) == 1 *)
                                        IF CastToDouble[land_end_element] = 1 THEN 
                                            (* '<S2>:388:6' if trucks_has_load(i) == 1 *)
                                            IF CastToDouble1[land_end_element] = 1 THEN 
                                                (* '<S2>:388:7' x_t_obj = -25 + (i-1)*5; *)
                                                x_t_obj := (((DINT_TO_LREAL(land_end_element) + 1.0) - 1.0) * 5.0) - 25.0;
                                            END_IF;
                                        END_IF;
                                    END_FOR;
                                    (* '<S2>:388:11' x_t_obj *)
                                    (* ...[x_t_ref, v_t_ref, ~, x_t_pr] = generador_trayectoria(t, x_t_est, x_t_obj, v_t_est, 1); *)
                                END_IF;
                            c_TO_C_IN_Truck_Placement_D: 
                                (* During 'Truck_Placement_Descend': '<S2>:628' *)
                                (* '<S2>:631:1' sf_internal_predicateOutput = hoist_stopped && trolley_stopped_complete; *)
                                IF hoist_stopped AND trolley_stopped_complete THEN 
                                    (* Transition: '<S2>:631' *)
                                    is_Pickup_And_Place_Loop := c_TO_CO_IN_Truck_Placement_;
                                    was_Pickup_And_Place_Loop := c_TO_CO_IN_Truck_Placement_;
                                    (* Entry 'Truck_Placement_Manual': '<S2>:630' *)
                                    (* '<S2>:630:3' operation_mode = false; *)
                                    operation_mode := FALSE;
                                END_IF;
                            c_TO_CO_IN_Truck_Placement_: 
                                (* During 'Truck_Placement_Manual': '<S2>:630' *)
                                (* '<S2>:632:1' sf_internal_predicateOutput = (l_h_sensor <=  l_h_obj-1 && ~TLK) && escenario == 2; *)
                                (* '<S2>:635:1' sf_internal_predicateOutput = (l_h_sensor <=  l_h_obj-1 && ~TLK) && escenario == 3; *)
                                IF (b_l_h_sensor <= (l_h_obj - 1.0)) AND ( NOT TLK) THEN 
                                    (* Transition: '<S2>:635' *)
                                    (* Exit 'Truck_Placement_Manual': '<S2>:630' *)
                                    (* '<S2>:630:5' m_est = 15000; *)
                                    m_est := 15000.0;
                                    is_Pickup_And_Place_Loop := c_TO_CODESYS_IN_Truck_Picku;
                                    was_Pickup_And_Place_Loop := c_TO_CODESYS_IN_Truck_Picku;
                                    (* Entry 'Truck_Pickup_Move': '<S2>:388' *)
                                    (* '<S2>:388:3' operation_mode = true; *)
                                    operation_mode := TRUE;
                                    (* '<S2>:388:4' for i = 1:5 *)
                                    FOR land_end_element := 0 TO 4 DO 
                                        (* '<S2>:388:5' if trucks_state(i) == 1 *)
                                        IF CastToDouble[land_end_element] = 1 THEN 
                                            (* '<S2>:388:6' if trucks_has_load(i) == 1 *)
                                            IF CastToDouble1[land_end_element] = 1 THEN 
                                                (* '<S2>:388:7' x_t_obj = -25 + (i-1)*5; *)
                                                x_t_obj := (((DINT_TO_LREAL(land_end_element) + 1.0) - 1.0) * 5.0) - 25.0;
                                            END_IF;
                                        END_IF;
                                    END_FOR;
                                    (* '<S2>:388:11' x_t_obj *)
                                    (* ...[x_t_ref, v_t_ref, ~, x_t_pr] = generador_trayectoria(t, x_t_est, x_t_obj, v_t_est, 1); *)
                                END_IF;
                            c_TO_CODE_IN_Truck_Placemen: 
                                (* During 'Truck_Placement_Move': '<S2>:626' *)
                                (* '<S2>:629:1' sf_internal_predicateOutput = trolley_stopped; *)
                                IF trolley_stopped THEN 
                                    (* Transition: '<S2>:629' *)
                                    is_Pickup_And_Place_Loop := c_TO_C_IN_Truck_Placement_D;
                                    was_Pickup_And_Place_Loop := c_TO_C_IN_Truck_Placement_D;
                                    (* Entry 'Truck_Placement_Descend': '<S2>:628' *)
                                    (* '<S2>:628:3' operation_mode = true; *)
                                    operation_mode := TRUE;
                                    (* '<S2>:628:4' l_h_obj = 45 - truck_pickup_height - pickup_safety_margin *)
                                    l_h_obj := 38.043;
                                    (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
                                END_IF;
                            ELSE
                                (* During 'Truck_Placement_Raise': '<S2>:624' *)
                                (* '<S2>:627:1' sf_internal_predicateOutput = hoist_stopped || l_h_pr > 0.8; *)
                                IF hoist_stopped OR (l_h_pr > 0.8) THEN 
                                    (* Transition: '<S2>:627' *)
                                    is_Pickup_And_Place_Loop := c_TO_CODE_IN_Truck_Placemen;
                                    was_Pickup_And_Place_Loop := c_TO_CODE_IN_Truck_Placemen;
                                    (* Entry 'Truck_Placement_Move': '<S2>:626' *)
                                    (* '<S2>:626:3' operation_mode = true; *)
                                    operation_mode := TRUE;
                                    (* '<S2>:626:4' for i = 1:5 *)
                                    FOR land_end_element := 0 TO 4 DO 
                                        (* '<S2>:626:5' if trucks_state(i) == 1 *)
                                        IF CastToDouble[land_end_element] = 1 THEN 
                                            (* '<S2>:626:6' if trucks_has_load(i) == 0 *)
                                            IF CastToDouble1[land_end_element] = 0 THEN 
                                                (* '<S2>:626:7' x_t_obj = -25 + (i-1)*5; *)
                                                x_t_obj := (((DINT_TO_LREAL(land_end_element) + 1.0) - 1.0) * 5.0) - 25.0;
                                            END_IF;
                                        END_IF;
                                    END_FOR;
                                    (* '<S2>:626:11' x_t_obj *)
                                    (* ...[x_t_ref, v_t_ref, ~, x_t_pr] = generador_trayectoria(t, x_t_est, x_t_obj, v_t_est, 1); *)
                                END_IF;
                        END_CASE;
                    END_IF;
                c_TO_CODESYS_IN_Scenario_Se: 
                    (* During 'Scenario_Selector': '<S2>:374' *)
                    (* '<S2>:379:1' sf_internal_predicateOutput = escenario == 0; *)
                    (* '<S2>:383:1' sf_internal_predicateOutput = escenario ~= 0; *)
                    (* Transition: '<S2>:383' *)
                    is_Trajectory_Planner := c_TO_COD_IN_Pickup_And_Plac;
                    (* Entry 'Pickup_And_Place_Loop': '<S2>:384' *)
                    (* Entry Internal 'Pickup_And_Place_Loop': '<S2>:384' *)
                    CASE was_Pickup_And_Place_Loop OF
                        TO_CODESYS_IN_Init: 
                            is_Pickup_And_Place_Loop := TO_CODESYS_IN_Init;
                            was_Pickup_And_Place_Loop := TO_CODESYS_IN_Init;
                        c_TO_CODES_IN_Scenario_Sele: 
                            is_Pickup_And_Place_Loop := c_TO_CODES_IN_Scenario_Sele;
                            was_Pickup_And_Place_Loop := c_TO_CODES_IN_Scenario_Sele;
                        c_TO_CO_IN_Ship_Palcement_D: 
                            is_Pickup_And_Place_Loop := c_TO_CO_IN_Ship_Palcement_D;
                            was_Pickup_And_Place_Loop := c_TO_CO_IN_Ship_Palcement_D;
                            (* Entry 'Ship_Palcement_Descend': '<S2>:572' *)
                            (* '<S2>:572:3' operation_mode = true; *)
                            operation_mode := TRUE;
                            (* ...l_h_obj = xpos2ypos(lidar_map, x_t_obj) - placement_safety_margin *)
                            (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
                        c_TO_CODES_IN_Ship_Pickup_D: 
                            is_Pickup_And_Place_Loop := c_TO_CODES_IN_Ship_Pickup_D;
                            was_Pickup_And_Place_Loop := c_TO_CODES_IN_Ship_Pickup_D;
                            (* Entry 'Ship_Pickup_Descend': '<S2>:620' *)
                            (* '<S2>:620:3' operation_mode = true; *)
                            operation_mode := TRUE;
                            (* ...l_h_obj = xpos2ypos(lidar_map, x_t_obj) - placement_safety_margin *)
                            (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
                        c_TO_CODESY_IN_Ship_Pickup_: 
                            is_Pickup_And_Place_Loop := c_TO_CODESY_IN_Ship_Pickup_;
                            was_Pickup_And_Place_Loop := c_TO_CODESY_IN_Ship_Pickup_;
                            (* Entry 'Ship_Pickup_Manual': '<S2>:622' *)
                            (* '<S2>:622:3' operation_mode = false; *)
                            operation_mode := FALSE;
                            (* '<S2>:622:4' m_est_vec_pos = 1; *)
                            m_est_vec_pos := 1.0;
                            (* '<S2>:622:5' m_est_vec(:) = 0; *)
                        c_TO_CODESYS_IN_Ship_Pickup: 
                            is_Pickup_And_Place_Loop := c_TO_CODESYS_IN_Ship_Pickup;
                            was_Pickup_And_Place_Loop := c_TO_CODESYS_IN_Ship_Pickup;
                            (* Entry 'Ship_Pickup_Move': '<S2>:618' *)
                            (* '<S2>:618:3' operation_mode = true; *)
                            operation_mode := TRUE;
                            (* '<S2>:618:4' max_containers = 0; *)
                            pillar_height := 0.0;
                            (* '<S2>:618:5' idx_obj = 1; *)
                            land_end_element := 1;
                            (* '<S2>:618:6' for i = 1:19 *)
                            FOR i := 0 TO 18 DO 
                                (* '<S2>:618:7' if container_pillars(i) > max_containers *)
                                container_pillars := b_container_pillars[i];
                                IF container_pillars > pillar_height THEN 
                                    (* '<S2>:618:8' max_containers = container_pillars(i); *)
                                    pillar_height := container_pillars;
                                    (* '<S2>:618:9' idx_obj = i; *)
                                    land_end_element := i + 1;
                                END_IF;
                            END_FOR;
                            (* '<S2>:618:12' espaciado = (x_containers_right_lim - x_containers_left_lim) / (19 - 1); *)
                            (* '<S2>:618:13' x_t_obj = x_containers_left_lim + (idx_obj - 1) * espaciado; *)
                            x_t_obj := ((DINT_TO_LREAL(land_end_element) - 1.0) * 2.6111111111111112) + c_TO_CODESY_x_containers_le;
                            (* '<S2>:618:14' x_t_obj *)
                            (* ...[x_t_ref, v_t_ref, ~, x_t_pr] = generador_trayectoria(t, x_t_est, x_t_obj, v_t_est,1 ); *)
                        d_TO_CODESYS_IN_Ship_Pickup: 
                            is_Pickup_And_Place_Loop := d_TO_CODESYS_IN_Ship_Pickup;
                            was_Pickup_And_Place_Loop := d_TO_CODESYS_IN_Ship_Pickup;
                            (* Entry 'Ship_Pickup_Raise': '<S2>:436' *)
                            (* '<S2>:436:3' operation_mode = true; *)
                            operation_mode := TRUE;
                            (* '<S2>:436:4' l_h_obj = l_h_safe; *)
                            l_h_obj := l_h_safe;
                            (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
                        c_TO_COD_IN_Ship_Placement_: 
                            is_Pickup_And_Place_Loop := c_TO_COD_IN_Ship_Placement_;
                            was_Pickup_And_Place_Loop := c_TO_COD_IN_Ship_Placement_;
                            (* Entry 'Ship_Placement_Manual': '<S2>:579' *)
                            (* '<S2>:579:3' operation_mode = false; *)
                            operation_mode := FALSE;
                        c_TO_CODES_IN_Ship_Placemen: 
                            is_Pickup_And_Place_Loop := c_TO_CODES_IN_Ship_Placemen;
                            was_Pickup_And_Place_Loop := c_TO_CODES_IN_Ship_Placemen;
                            (* Entry 'Ship_Placement_Move': '<S2>:391' *)
                            (* '<S2>:391:3' operation_mode = true; *)
                            operation_mode := TRUE;
                            (* '<S2>:391:4' min_containers = 999; *)
                            pillar_height := 999.0;
                            (* '<S2>:391:5' idx_obj = 1; *)
                            land_end_element := 1;
                            (* '<S2>:391:6' for i = 1:19 *)
                            FOR i := 0 TO 18 DO 
                                (* '<S2>:391:7' if container_pillars(i) < min_containers *)
                                container_pillars := b_container_pillars[i];
                                IF container_pillars < pillar_height THEN 
                                    (* '<S2>:391:8' min_containers = container_pillars(i); *)
                                    pillar_height := container_pillars;
                                    (* '<S2>:391:9' idx_obj = i; *)
                                    land_end_element := i + 1;
                                END_IF;
                            END_FOR;
                            (* '<S2>:391:12' espaciado = (x_containers_right_lim - x_containers_left_lim) / (19 - 1); *)
                            (* '<S2>:391:13' x_t_obj = x_containers_left_lim + (idx_obj - 1) * espaciado; *)
                            x_t_obj := ((DINT_TO_LREAL(land_end_element) - 1.0) * 2.6111111111111112) + c_TO_CODESY_x_containers_le;
                            (* '<S2>:391:14' x_t_obj *)
                            (* ...[x_t_ref, v_t_ref, ~, x_t_pr] = generador_trayectoria(t, x_t_est, x_t_obj, v_t_est,1 ); *)
                        c_TO_CODE_IN_Ship_Placement: 
                            is_Pickup_And_Place_Loop := c_TO_CODE_IN_Ship_Placement;
                            was_Pickup_And_Place_Loop := c_TO_CODE_IN_Ship_Placement;
                            (* Entry 'Ship_Placement_Raise': '<S2>:570' *)
                            (* '<S2>:570:3' operation_mode = true; *)
                            operation_mode := TRUE;
                            (* '<S2>:570:4' l_h_obj = l_h_safe; *)
                            l_h_obj := l_h_safe;
                            (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
                        c_TO_CODE_IN_Truck_Pickup_D: 
                            is_Pickup_And_Place_Loop := c_TO_CODE_IN_Truck_Pickup_D;
                            was_Pickup_And_Place_Loop := c_TO_CODE_IN_Truck_Pickup_D;
                            (* Entry 'Truck_Pickup_Descend': '<S2>:564' *)
                            (* '<S2>:564:3' operation_mode = true; *)
                            operation_mode := TRUE;
                            (* '<S2>:564:4' l_h_obj = 45 - truck_pickup_height - pickup_safety_margin *)
                            l_h_obj := 38.043;
                            (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
                        c_TO_CODES_IN_Truck_Pickup_: 
                            is_Pickup_And_Place_Loop := c_TO_CODES_IN_Truck_Pickup_;
                            was_Pickup_And_Place_Loop := c_TO_CODES_IN_Truck_Pickup_;
                            (* Entry 'Truck_Pickup_Manual': '<S2>:577' *)
                            (* '<S2>:577:3' operation_mode = false; *)
                            operation_mode := FALSE;
                            (* '<S2>:577:4' m_est_vec_pos = 1; *)
                            m_est_vec_pos := 1.0;
                            (* '<S2>:577:5' m_est_vec(:) = 0; *)
                        c_TO_CODESYS_IN_Truck_Picku: 
                            is_Pickup_And_Place_Loop := c_TO_CODESYS_IN_Truck_Picku;
                            was_Pickup_And_Place_Loop := c_TO_CODESYS_IN_Truck_Picku;
                            (* Entry 'Truck_Pickup_Move': '<S2>:388' *)
                            (* '<S2>:388:3' operation_mode = true; *)
                            operation_mode := TRUE;
                            (* '<S2>:388:4' for i = 1:5 *)
                            FOR land_end_element := 0 TO 4 DO 
                                (* '<S2>:388:5' if trucks_state(i) == 1 *)
                                IF CastToDouble[land_end_element] = 1 THEN 
                                    (* '<S2>:388:6' if trucks_has_load(i) == 1 *)
                                    IF CastToDouble1[land_end_element] = 1 THEN 
                                        (* '<S2>:388:7' x_t_obj = -25 + (i-1)*5; *)
                                        x_t_obj := (((DINT_TO_LREAL(land_end_element) + 1.0) - 1.0) * 5.0) - 25.0;
                                    END_IF;
                                END_IF;
                            END_FOR;
                            (* '<S2>:388:11' x_t_obj *)
                            (* ...[x_t_ref, v_t_ref, ~, x_t_pr] = generador_trayectoria(t, x_t_est, x_t_obj, v_t_est, 1); *)
                        c_TO_CODESY_IN_Truck_Pickup: 
                            is_Pickup_And_Place_Loop := c_TO_CODESY_IN_Truck_Pickup;
                            was_Pickup_And_Place_Loop := c_TO_CODESY_IN_Truck_Pickup;
                            (* Entry 'Truck_Pickup_Raise': '<S2>:566' *)
                            (* '<S2>:566:3' operation_mode = true; *)
                            operation_mode := TRUE;
                            (* '<S2>:566:4' l_h_obj = l_h_safe; *)
                            l_h_obj := l_h_safe;
                            (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
                        c_TO_C_IN_Truck_Placement_D: 
                            is_Pickup_And_Place_Loop := c_TO_C_IN_Truck_Placement_D;
                            was_Pickup_And_Place_Loop := c_TO_C_IN_Truck_Placement_D;
                            (* Entry 'Truck_Placement_Descend': '<S2>:628' *)
                            (* '<S2>:628:3' operation_mode = true; *)
                            operation_mode := TRUE;
                            (* '<S2>:628:4' l_h_obj = 45 - truck_pickup_height - pickup_safety_margin *)
                            l_h_obj := 38.043;
                            (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
                        c_TO_CO_IN_Truck_Placement_: 
                            is_Pickup_And_Place_Loop := c_TO_CO_IN_Truck_Placement_;
                            was_Pickup_And_Place_Loop := c_TO_CO_IN_Truck_Placement_;
                            (* Entry 'Truck_Placement_Manual': '<S2>:630' *)
                            (* '<S2>:630:3' operation_mode = false; *)
                            operation_mode := FALSE;
                        c_TO_CODE_IN_Truck_Placemen: 
                            is_Pickup_And_Place_Loop := c_TO_CODE_IN_Truck_Placemen;
                            was_Pickup_And_Place_Loop := c_TO_CODE_IN_Truck_Placemen;
                            (* Entry 'Truck_Placement_Move': '<S2>:626' *)
                            (* '<S2>:626:3' operation_mode = true; *)
                            operation_mode := TRUE;
                            (* '<S2>:626:4' for i = 1:5 *)
                            FOR land_end_element := 0 TO 4 DO 
                                (* '<S2>:626:5' if trucks_state(i) == 1 *)
                                IF CastToDouble[land_end_element] = 1 THEN 
                                    (* '<S2>:626:6' if trucks_has_load(i) == 0 *)
                                    IF CastToDouble1[land_end_element] = 0 THEN 
                                        (* '<S2>:626:7' x_t_obj = -25 + (i-1)*5; *)
                                        x_t_obj := (((DINT_TO_LREAL(land_end_element) + 1.0) - 1.0) * 5.0) - 25.0;
                                    END_IF;
                                END_IF;
                            END_FOR;
                            (* '<S2>:626:11' x_t_obj *)
                            (* ...[x_t_ref, v_t_ref, ~, x_t_pr] = generador_trayectoria(t, x_t_est, x_t_obj, v_t_est, 1); *)
                        c_TO_COD_IN_Truck_Placement: 
                            is_Pickup_And_Place_Loop := c_TO_COD_IN_Truck_Placement;
                            was_Pickup_And_Place_Loop := c_TO_COD_IN_Truck_Placement;
                            (* Entry 'Truck_Placement_Raise': '<S2>:624' *)
                            (* '<S2>:624:3' operation_mode = true; *)
                            operation_mode := TRUE;
                            (* '<S2>:624:4' l_h_obj = l_h_safe; *)
                            l_h_obj := l_h_safe;
                            (* ...[l_h_ref, dl_h_ref, ~, l_h_pr] = generador_trayectoria_izaje(t, l_h_sensor, v_t_est, l_h_obj, m_est, 1); *)
                        ELSE
                            (* Transition: '<S2>:389' *)
                            is_Pickup_And_Place_Loop := TO_CODESYS_IN_Init;
                            was_Pickup_And_Place_Loop := TO_CODESYS_IN_Init;
                    END_CASE;
                ELSE
                    (* During 'Waiting': '<S2>:376' *)
                    (* '<S2>:380:1' sf_internal_predicateOutput = escenario ~= 0; *)
                    (* Transition: '<S2>:380' *)
                    is_Trajectory_Planner := c_TO_CODESYS_IN_Scenario_Se;
                    (* Entry 'Scenario_Selector': '<S2>:374' *)
                    (* '<S2>:374:3' sway_ctr_gain = 1; *)
                    sway_ctr_gain := 1.0;
            END_CASE;
            (* During 'Trolley_Movement_Flags': '<S2>:481' *)
            CASE is_Trolley_Movement_Flags OF
                c_TO_CODESYS_IN_Trolley_Mov: 
                    (* During 'Trolley_Moving': '<S2>:482' *)
                    (* '<S2>:487:1' sf_internal_predicateOutput = abs(x_t_est-x_t_obj) <= 0.03 && abs(v_t_est) <= 0.05; *)
                    IF ABS(x_t_est - x_t_obj) <= 0.03 THEN 
                        IF ABS(v_t_est) <= 0.05 THEN 
                            (* Transition: '<S2>:487' *)
                            is_Trolley_Movement_Flags := c_TO_CODESYS_IN_Trolley_Sto;
                            (* Entry 'Trolley_Stopped': '<S2>:484' *)
                            (* '<S2>:484:3' trolley_moving = false; *)
                            (* '<S2>:484:4' trolley_stopped = true; *)
                            trolley_stopped := TRUE;
                            (* '<S2>:484:5' trolley_stopped_complete = false; *)
                            trolley_stopped_complete := FALSE;
                        END_IF;
                    END_IF;
                c_TO_CODESYS_IN_Trolley_Sto: 
                    (* During 'Trolley_Stopped': '<S2>:484' *)
                    (* '<S2>:488:1' sf_internal_predicateOutput = abs(x_t_est-x_t_obj) > 0.1 || abs(v_t_est) > 0.1; *)
                    temp1 := FALSE;
                    IF ABS(x_t_est - x_t_obj) > 0.1 THEN 
                        temp1 := TRUE;
                    ELSIF ABS(v_t_est) > 0.1 THEN 
                        temp1 := TRUE;
                    ELSE 
                        (* '<S2>:490:1' sf_internal_predicateOutput = abs(w_l_sensor) <= 0.005 && abs(theta_l_sensor) <= 0.005; *)
                        IF ABS(w_l_sensor) <= 0.005 THEN 
                            IF ABS(theta_l_sensor) <= 0.005 THEN 
                                (* Transition: '<S2>:490' *)
                                is_Trolley_Movement_Flags := c_TOZZIN_Trolley_Stopped_Co;
                                (* Entry 'Trolley_Stopped_Complete': '<S2>:489' *)
                                (* '<S2>:489:3' trolley_moving = false; *)
                                (* '<S2>:489:4' trolley_stopped = true; *)
                                trolley_stopped := TRUE;
                                (* '<S2>:489:5' trolley_stopped_complete = true; *)
                                trolley_stopped_complete := TRUE;
                            END_IF;
                        END_IF;
                    END_IF;
                    IF temp1 THEN 
                        (* Transition: '<S2>:488' *)
                        is_Trolley_Movement_Flags := c_TO_CODESYS_IN_Trolley_Mov;
                        (* Entry 'Trolley_Moving': '<S2>:482' *)
                        (* '<S2>:482:3' trolley_moving = true; *)
                        (* '<S2>:482:4' trolley_stopped = false; *)
                        trolley_stopped := FALSE;
                        (* '<S2>:482:5' trolley_stopped_complete = false; *)
                        trolley_stopped_complete := FALSE;
                    END_IF;
                ELSE
                    (* During 'Trolley_Stopped_Complete': '<S2>:489' *)
                    (* '<S2>:491:1' sf_internal_predicateOutput = abs(w_l_sensor) > 0.01 || abs(theta_l_sensor) > 0.01; *)
                    temp1 := FALSE;
                    IF ABS(w_l_sensor) > 0.01 THEN 
                        temp1 := TRUE;
                    ELSIF ABS(theta_l_sensor) > 0.01 THEN 
                        temp1 := TRUE;
                    ELSE 
                        (* '<S2>:492:1' sf_internal_predicateOutput = abs(x_t_est-x_t_obj) > 0.15 || abs(v_t_est) > 0.15; *)
                        temp2 := FALSE;
                        IF ABS(x_t_est - x_t_obj) > 0.15 THEN 
                            temp2 := TRUE;
                        ELSIF ABS(v_t_est) > 0.15 THEN 
                            temp2 := TRUE;
                        END_IF;
                        IF temp2 THEN 
                            (* Transition: '<S2>:492' *)
                            is_Trolley_Movement_Flags := c_TO_CODESYS_IN_Trolley_Mov;
                            (* Entry 'Trolley_Moving': '<S2>:482' *)
                            (* '<S2>:482:3' trolley_moving = true; *)
                            (* '<S2>:482:4' trolley_stopped = false; *)
                            trolley_stopped := FALSE;
                            (* '<S2>:482:5' trolley_stopped_complete = false; *)
                            trolley_stopped_complete := FALSE;
                        END_IF;
                    END_IF;
                    IF temp1 THEN 
                        (* Transition: '<S2>:491' *)
                        is_Trolley_Movement_Flags := c_TO_CODESYS_IN_Trolley_Sto;
                        (* Entry 'Trolley_Stopped': '<S2>:484' *)
                        (* '<S2>:484:3' trolley_moving = false; *)
                        (* '<S2>:484:4' trolley_stopped = true; *)
                        trolley_stopped := TRUE;
                        (* '<S2>:484:5' trolley_stopped_complete = false; *)
                        trolley_stopped_complete := FALSE;
                    END_IF;
            END_CASE;
            (* During 'Hoist_Movement_Flags': '<S2>:511' *)
            CASE is_Hoist_Movement_Flags OF
                TO_CODESYS_IN_Hoist_Moving: 
                    (* During 'Hoist_Moving': '<S2>:512' *)
                    (* '<S2>:508:1' sf_internal_predicateOutput = abs(l_h_sensor-l_h_obj) <= 0.05 && abs(dl_h_est) <= 0.05; *)
                    IF ABS(b_l_h_sensor - l_h_obj) <= 0.05 THEN 
                        IF ABS(Gain3) <= 0.05 THEN 
                            (* Transition: '<S2>:508' *)
                            is_Hoist_Movement_Flags := TO_CODESYS_IN_Hoist_Stopped;
                            (* Entry 'Hoist_Stopped': '<S2>:509' *)
                            (* '<S2>:509:3' hoist_moving = false; *)
                            (* '<S2>:509:4' hoist_stopped = true; *)
                            hoist_stopped := TRUE;
                        END_IF;
                    END_IF;
                ELSE
                    (* During 'Hoist_Stopped': '<S2>:509' *)
                    (* '<S2>:510:1' sf_internal_predicateOutput = abs(l_h_sensor-l_h_obj) > 0.1 || abs(dl_h_est) > 0.1; *)
                    temp1 := FALSE;
                    IF ABS(b_l_h_sensor - l_h_obj) > 0.1 THEN 
                        temp1 := TRUE;
                    ELSIF ABS(Gain3) > 0.1 THEN 
                        temp1 := TRUE;
                    END_IF;
                    IF temp1 THEN 
                        (* Transition: '<S2>:510' *)
                        is_Hoist_Movement_Flags := TO_CODESYS_IN_Hoist_Moving;
                        (* Entry 'Hoist_Moving': '<S2>:512' *)
                        (* '<S2>:512:3' hoist_moving = true; *)
                        (* '<S2>:512:4' hoist_stopped = false; *)
                        hoist_stopped := FALSE;
                    END_IF;
            END_CASE;
        END_IF;
        (* Chart: '<S1>/Nivel 0 - Seguridad y Protección' incorporates:
         *  Outport: '<Root>/BRK_h'
         *  Outport: '<Root>/BRK_hE'
         *  Outport: '<Root>/BRK_t'
         *  Outport: '<Root>/dl_h_ref'
         *  Outport: '<Root>/hoist_emgy'
         *  Outport: '<Root>/l_h_ref'
         *  Outport: '<Root>/sway_ctr_enable'
         *  Outport: '<Root>/trolley_emgy'
         *  Outport: '<Root>/v_t_ref'
         *  Outport: '<Root>/x_t_ref' *)
        (* Gateway: TO_CODESYS/Nivel 0 - Seguridad y Protección *)
        (* During: TO_CODESYS/Nivel 0 - Seguridad y Protección *)
        (* During 'Safety_Security_Control': '<S3>:1' *)
        (* During 'Emergencies': '<S3>:10' *)
        CASE is_Emergencies OF
            TO_CODESYS_IN_Global_Emgy: 
                (* During 'Global_Emgy': '<S3>:30' *)
                (* '<S3>:88:1' sf_internal_predicateOutput = after(3000,msec); *)
                temporalCounter_i1(timerAction := 2, maxTime := 3000);
                IF temporalCounter_i1.done THEN 
                    (* Transition: '<S3>:88' *)
                    is_Emergencies := c_TO_C_IN_Waiting_Global_Em;
                ELSE 
                    (* '<S3>:30:9' v_t_ref = 0; *)
                    v_t_ref := 0.0;
                    (* '<S3>:30:10' dl_h_ref = 0; *)
                    dl_h_ref := 0.0;
                END_IF;
            TO_CODESYS_IN_Hoist_Emgy: 
                (* During 'Hoist_Emgy': '<S3>:31' *)
                (* '<S3>:102:1' sf_internal_predicateOutput = hoist_solved; *)
                IF hoist_solved THEN 
                    (* Transition: '<S3>:102' *)
                    (* Exit Internal 'Hoist_Emgy': '<S3>:31' *)
                    is_Hoist_Emgy := c_TO_CODESYS_IN_NO_ACTIVE_C;
                    is_Emergencies := TO_CODESYS_IN_Stand_By;
                    (* Entry 'Stand_By': '<S3>:27' *)
                    (* '<S3>:27:3' hoist_solved = false; *)
                    hoist_solved := FALSE;
                    (* '<S3>:27:4' trolley_solved = false; *)
                    trolley_solved := FALSE;
                    (* '<S3>:27:5' emgy = false; *)
                    emgy := FALSE;
                ELSE 
                    CASE is_Hoist_Emgy OF
                        c_TO_CODESYS_IN_Emgy_Switch: 
                            (* During 'Emgy_Switch_Max': '<S3>:53' *)
                            (* '<S3>:85:1' sf_internal_predicateOutput = l_h <= l_h_safety_max; *)
                            IF b_l_h_sensor <= TO_CODESYS_l_h_safety_max THEN 
                                (* Transition: '<S3>:85' *)
                                is_Hoist_Emgy := TO_CODESYS_IN_Solved;
                                (* Entry 'Solved': '<S3>:58' *)
                                (* '<S3>:58:3' hoist_emgy = false; *)
                                hoist_emgy := FALSE;
                                (* '<S3>:58:4' hoist_solved = true; *)
                                hoist_solved := TRUE;
                            ELSE 
                                (* '<S3>:53:6' v_t_ref = vx_joystick; *)
                                v_t_ref := JS_trolley_cmd;
                                (* '<S3>:53:7' dl_h_ref = min([max([vy_joystick, -0.5]), 0]); *)
                                JS_hoist_cmd_0[0] := JS_hoist_cmd;
                                JS_hoist_cmd_0[1] := -0.5;
                                tmp[0] := maximum_d(x := JS_hoist_cmd_0);
                                tmp[1] := 0.0;
                                dl_h_ref := minimum(x := tmp);
                            END_IF;
                        d_TO_CODESYS_IN_Emgy_Switch: 
                            (* During 'Emgy_Switch_Min': '<S3>:52' *)
                            (* '<S3>:86:1' sf_internal_predicateOutput = l_h >= l_h_safety_min; *)
                            IF b_l_h_sensor >= TO_CODESYS_l_h_safety_min THEN 
                                (* Transition: '<S3>:86' *)
                                is_Hoist_Emgy := TO_CODESYS_IN_Solved;
                                (* Entry 'Solved': '<S3>:58' *)
                                (* '<S3>:58:3' hoist_emgy = false; *)
                                hoist_emgy := FALSE;
                                (* '<S3>:58:4' hoist_solved = true; *)
                                hoist_solved := TRUE;
                            ELSE 
                                (* '<S3>:52:6' v_t_ref = vx_joystick; *)
                                v_t_ref := JS_trolley_cmd;
                                (* '<S3>:52:7' dl_h_ref = max([min([vy_joystick, 0.5]), 0]); *)
                                JS_hoist_cmd_0[0] := JS_hoist_cmd;
                                JS_hoist_cmd_0[1] := 0.5;
                                tmp[0] := minimum(x := JS_hoist_cmd_0);
                                tmp[1] := 0.0;
                                dl_h_ref := maximum_d(x := tmp);
                            END_IF;
                        TO_CODESYS_IN_Init_e: 
                            (* During 'Init': '<S3>:50' *)
                            (* '<S3>:55:1' sf_internal_predicateOutput = FCE_izaje_min && after(3000, msec); *)
                            temp1 := FALSE;
                            IF FCE_izaje_min THEN 
                                temporalCounter_i1(timerAction := 2, maxTime := 3000);
                                IF temporalCounter_i1.done THEN 
                                    (* Transition: '<S3>:55' *)
                                    is_Hoist_Emgy := d_TO_CODESYS_IN_Emgy_Switch;
                                    (* Entry 'Emgy_Switch_Min': '<S3>:52' *)
                                    (* '<S3>:52:3' BRK_h = true; *)
                                    BRK_h := TRUE;
                                    (* '<S3>:52:4' BRK_hE = true; *)
                                    BRK_hE := TRUE;
                                ELSE 
                                    temp1 := TRUE;
                                END_IF;
                            ELSE 
                                temp1 := TRUE;
                            END_IF;
                            IF temp1 THEN 
                                (* '<S3>:56:1' sf_internal_predicateOutput = FCE_izaje_max && after(3000, msec); *)
                                temp2 := FALSE;
                                IF FCE_izaje_max THEN 
                                    temporalCounter_i3(timerAction := 2, maxTime := 3000);
                                    IF temporalCounter_i3.done THEN 
                                        (* Transition: '<S3>:56' *)
                                        is_Hoist_Emgy := c_TO_CODESYS_IN_Emgy_Switch;
                                        (* Entry 'Emgy_Switch_Max': '<S3>:53' *)
                                        (* '<S3>:53:3' BRK_h = true; *)
                                        BRK_h := TRUE;
                                        (* '<S3>:53:4' BRK_hE = true; *)
                                        BRK_hE := TRUE;
                                    ELSE 
                                        temp2 := TRUE;
                                    END_IF;
                                ELSE 
                                    temp2 := TRUE;
                                END_IF;
                                IF temp2 THEN 
                                    (* '<S3>:57:1' sf_internal_predicateOutput = sobrevelocidad_izaje; *)
                                    IF sobrevelocidad_izaje THEN 
                                        (* Transition: '<S3>:57' *)
                                        is_Hoist_Emgy := c_TO_CODESYS_IN_NO_ACTIVE_C;
                                        temporalCounter_i1(timerAction := 1, maxTime := 0);
                                        is_Hoist_Emgy := c_TO_CODESYS_IN_Overspeed_D;
                                    ELSE 
                                        (* '<S3>:125:1' sf_internal_predicateOutput = after(10, sec); *)
                                        temporalCounter_i2(timerAction := 2, maxTime := 10000);
                                        IF temporalCounter_i2.done THEN 
                                            (* Transition: '<S3>:125' *)
                                            is_Hoist_Emgy := TO_CODESYS_IN_Solved;
                                            (* Entry 'Solved': '<S3>:58' *)
                                            (* '<S3>:58:3' hoist_emgy = false; *)
                                            hoist_emgy := FALSE;
                                            (* '<S3>:58:4' hoist_solved = true; *)
                                            hoist_solved := TRUE;
                                        END_IF;
                                    END_IF;
                                END_IF;
                            END_IF;
                        TO_CODESYS_IN_Overspeed: 
                            (* During 'Overspeed': '<S3>:54' *)
                            (* '<S3>:60:1' sf_internal_predicateOutput = after(500, msec); *)
                            temporalCounter_i1(timerAction := 2, maxTime := 500);
                            IF temporalCounter_i1.done THEN 
                                (* Transition: '<S3>:60' *)
                                is_Hoist_Emgy := TO_CODESYS_IN_Solved;
                                (* Entry 'Solved': '<S3>:58' *)
                                (* '<S3>:58:3' hoist_emgy = false; *)
                                hoist_emgy := FALSE;
                                (* '<S3>:58:4' hoist_solved = true; *)
                                hoist_solved := TRUE;
                            END_IF;
                        c_TO_CODESYS_IN_Overspeed_D: 
                            (* During 'Overspeed_Delay': '<S3>:105' *)
                            (* '<S3>:106:1' sf_internal_predicateOutput = after(3000, msec); *)
                            temporalCounter_i1(timerAction := 2, maxTime := 3000);
                            IF temporalCounter_i1.done THEN 
                                (* Transition: '<S3>:106' *)
                                is_Hoist_Emgy := c_TO_CODESYS_IN_NO_ACTIVE_C;
                                temporalCounter_i1(timerAction := 1, maxTime := 0);
                                is_Hoist_Emgy := TO_CODESYS_IN_Overspeed;
                                (* Entry 'Overspeed': '<S3>:54' *)
                                (* '<S3>:54:3' BRK_h = true; *)
                                BRK_h := TRUE;
                                (* '<S3>:54:4' BRK_hE = true; *)
                                BRK_hE := TRUE;
                            END_IF;
                    END_CASE;
                END_IF;
            TO_CODESYS_IN_Stand_By: 
                (* During 'Stand_By': '<S3>:27' *)
                (* '<S3>:34:1' sf_internal_predicateOutput = cmd_emgy_stop || watchdog_fail; *)
                IF JS_emgy_cmd OR watchdog_fail THEN 
                    (* Transition: '<S3>:34' *)
                    is_Emergencies := c_TO_CODESYS_IN_NO_ACTIVE_C;
                    temporalCounter_i1(timerAction := 1, maxTime := 0);
                    is_Emergencies := TO_CODESYS_IN_Global_Emgy;
                    (* Entry 'Global_Emgy': '<S3>:30' *)
                    (* '<S3>:30:3' BRK_hE = false; *)
                    BRK_hE := FALSE;
                    (* '<S3>:30:4' BRK_t = false; *)
                    BRK_t := FALSE;
                    (* '<S3>:30:5' BRK_h = false; *)
                    BRK_h := FALSE;
                    (* '<S3>:30:6' emgy = true; *)
                    emgy := TRUE;
                    (* '<S3>:30:7' sway_ctr_enable = false; *)
                    sway_ctr_enable := FALSE;
                ELSE 
                    (* '<S3>:33:1' sf_internal_predicateOutput = FCE_izaje_min || FCE_izaje_max || sobrevelocidad_izaje; *)
                    IF (FCE_izaje_min OR FCE_izaje_max) OR sobrevelocidad_izaje THEN 
                        (* Transition: '<S3>:33' *)
                        is_Emergencies := TO_CODESYS_IN_Hoist_Emgy;
                        (* Entry 'Hoist_Emgy': '<S3>:31' *)
                        (* '<S3>:31:3' hoist_emgy = true; *)
                        hoist_emgy := TRUE;
                        (* '<S3>:31:4' BRK_hE = false; *)
                        BRK_hE := FALSE;
                        (* '<S3>:31:5' BRK_h = false; *)
                        BRK_h := FALSE;
                        (* '<S3>:31:6' hoist_solved = false; *)
                        hoist_solved := FALSE;
                        (* '<S3>:31:7' dl_h_ref = 0; *)
                        dl_h_ref := 0.0;
                        (* Entry Internal 'Hoist_Emgy': '<S3>:31' *)
                        (* Transition: '<S3>:51' *)
                        temporalCounter_i1(timerAction := 1, maxTime := 0);
                        temporalCounter_i2(timerAction := 1, maxTime := 0);
                        temporalCounter_i3(timerAction := 1, maxTime := 0);
                        is_Hoist_Emgy := TO_CODESYS_IN_Init_e;
                        (* Entry 'Init': '<S3>:50' *)
                    ELSE 
                        (* '<S3>:32:1' sf_internal_predicateOutput = FCE_carro_max || FCE_carro_min || sobrevelocidad_carro; *)
                        IF (FCE_carro_max OR FCE_carro_min) OR sobrevelocidad_carro THEN 
                            (* Transition: '<S3>:32' *)
                            is_Emergencies := TO_CODESYS_IN_Trolley_Emgy;
                            (* Entry 'Trolley_Emgy': '<S3>:29' *)
                            (* '<S3>:29:3' trolley_emgy = true; *)
                            trolley_emgy := TRUE;
                            (* '<S3>:29:4' BRK_t = false; *)
                            BRK_t := FALSE;
                            (* '<S3>:29:5' trolley_solved = false; *)
                            trolley_solved := FALSE;
                            (* '<S3>:29:6' v_t_ref = 0; *)
                            v_t_ref := 0.0;
                            (* '<S3>:29:7' x_t_ref = x_t_estimada; *)
                            x_t_ref := x_t_est;
                            (* Entry Internal 'Trolley_Emgy': '<S3>:29' *)
                            (* Transition: '<S3>:36' *)
                            temporalCounter_i1(timerAction := 1, maxTime := 0);
                            temporalCounter_i2(timerAction := 1, maxTime := 0);
                            temporalCounter_i3(timerAction := 1, maxTime := 0);
                            is_Trolley_Emgy := TO_CODESYS_IN_Init_e;
                        ELSE 
                            (* '<S3>:27:7' BRK_hE = true; *)
                            BRK_hE := TRUE;
                            (* '<S3>:27:8' v_t_ref = v_t_ref_nvl_1; *)
                            v_t_ref := v_t_ref_g;
                            (* '<S3>:27:9' dl_h_ref = dl_h_ref_nvl_1; *)
                            dl_h_ref := dl_h_ref_d;
                            (* '<S3>:27:10' BRK_h = BRK_h_nvl_1; *)
                            BRK_h := BRK_h_d;
                            (* '<S3>:27:11' BRK_t = BRK_t_nvl_1; *)
                            BRK_t := BRK_t_c;
                            (* '<S3>:27:12' sway_ctr_enable = sway_ctr_enable_nvl_1; *)
                            sway_ctr_enable := sway_ctr_enable_i;
                            (* '<S3>:27:13' x_t_ref = x_t_ref_nvl_1; *)
                            x_t_ref := x_t_ref_j;
                            (* '<S3>:27:14' l_h_ref = l_h_ref_nvl_1 *)
                            l_h_ref := l_h_ref_g;
                        END_IF;
                    END_IF;
                END_IF;
            TO_CODESYS_IN_Trolley_Emgy: 
                (* During 'Trolley_Emgy': '<S3>:29' *)
                (* '<S3>:49:1' sf_internal_predicateOutput = trolley_solved; *)
                IF trolley_solved THEN 
                    (* Transition: '<S3>:49' *)
                    (* Exit Internal 'Trolley_Emgy': '<S3>:29' *)
                    (* Exit Internal 'Overspeed': '<S3>:39' *)
                    is_Overspeed := c_TO_CODESYS_IN_NO_ACTIVE_C;
                    is_Trolley_Emgy := c_TO_CODESYS_IN_NO_ACTIVE_C;
                    is_Emergencies := TO_CODESYS_IN_Stand_By;
                    (* Entry 'Stand_By': '<S3>:27' *)
                    (* '<S3>:27:3' hoist_solved = false; *)
                    hoist_solved := FALSE;
                    (* '<S3>:27:4' trolley_solved = false; *)
                    trolley_solved := FALSE;
                    (* '<S3>:27:5' emgy = false; *)
                    emgy := FALSE;
                ELSE 
                    CASE is_Trolley_Emgy OF
                        c_TO_CODESYS_IN_Emgy_Switch: 
                            (* During 'Emgy_Switch_Max': '<S3>:38' *)
                            (* '<S3>:84:1' sf_internal_predicateOutput = x_t_estimada <= x_t_safety_max; *)
                            IF x_t_est <= TO_CODESYS_x_t_safety_max THEN 
                                (* Transition: '<S3>:84' *)
                                is_Trolley_Emgy := TO_CODESYS_IN_Solved;
                                (* Entry 'Solved': '<S3>:47' *)
                                (* '<S3>:47:3' trolley_emgy = false; *)
                                trolley_emgy := FALSE;
                                (* '<S3>:47:4' trolley_solved = true; *)
                                trolley_solved := TRUE;
                            ELSE 
                                (* '<S3>:38:5' v_t_ref = min([max([vx_joystick, -0.5]), 0]); *)
                                JS_hoist_cmd_0[0] := JS_trolley_cmd;
                                JS_hoist_cmd_0[1] := -0.5;
                                tmp[0] := maximum_d(x := JS_hoist_cmd_0);
                                tmp[1] := 0.0;
                                v_t_ref := minimum(x := tmp);
                                (* '<S3>:38:6' dl_h_ref = vy_joystick; *)
                                dl_h_ref := JS_hoist_cmd;
                            END_IF;
                        d_TO_CODESYS_IN_Emgy_Switch: 
                            (* During 'Emgy_Switch_Min': '<S3>:37' *)
                            (* '<S3>:83:1' sf_internal_predicateOutput = x_t_estimada >= x_t_safety_min; *)
                            IF x_t_est >= TO_CODESYS_x_t_safety_min THEN 
                                (* Transition: '<S3>:83' *)
                                is_Trolley_Emgy := TO_CODESYS_IN_Solved;
                                (* Entry 'Solved': '<S3>:47' *)
                                (* '<S3>:47:3' trolley_emgy = false; *)
                                trolley_emgy := FALSE;
                                (* '<S3>:47:4' trolley_solved = true; *)
                                trolley_solved := TRUE;
                            ELSE 
                                (* '<S3>:37:5' v_t_ref = max([min([vx_joystick, 0.5]), 0]); *)
                                JS_hoist_cmd_0[0] := JS_trolley_cmd;
                                JS_hoist_cmd_0[1] := 0.5;
                                tmp[0] := minimum(x := JS_hoist_cmd_0);
                                tmp[1] := 0.0;
                                v_t_ref := maximum_d(x := tmp);
                                (* '<S3>:37:6' dl_h_ref = vy_joystick; *)
                                dl_h_ref := JS_hoist_cmd;
                            END_IF;
                        TO_CODESYS_IN_Init_e: 
                            (* During 'Init': '<S3>:35' *)
                            (* '<S3>:40:1' sf_internal_predicateOutput = FCE_carro_min && after(3000, msec); *)
                            temp1 := FALSE;
                            IF FCE_carro_min THEN 
                                temporalCounter_i1(timerAction := 2, maxTime := 3000);
                                IF temporalCounter_i1.done THEN 
                                    (* Transition: '<S3>:40' *)
                                    is_Trolley_Emgy := d_TO_CODESYS_IN_Emgy_Switch;
                                    (* Entry 'Emgy_Switch_Min': '<S3>:37' *)
                                    (* '<S3>:37:3' BRK_t = true; *)
                                    BRK_t := TRUE;
                                ELSE 
                                    temp1 := TRUE;
                                END_IF;
                            ELSE 
                                temp1 := TRUE;
                            END_IF;
                            IF temp1 THEN 
                                (* '<S3>:41:1' sf_internal_predicateOutput = FCE_carro_max && after(3000, msec); *)
                                temp2 := FALSE;
                                IF FCE_carro_max THEN 
                                    temporalCounter_i3(timerAction := 2, maxTime := 3000);
                                    IF temporalCounter_i3.done THEN 
                                        (* Transition: '<S3>:41' *)
                                        is_Trolley_Emgy := c_TO_CODESYS_IN_Emgy_Switch;
                                        (* Entry 'Emgy_Switch_Max': '<S3>:38' *)
                                        (* '<S3>:38:3' BRK_t = true; *)
                                        BRK_t := TRUE;
                                    ELSE 
                                        temp2 := TRUE;
                                    END_IF;
                                ELSE 
                                    temp2 := TRUE;
                                END_IF;
                                IF temp2 THEN 
                                    (* '<S3>:42:1' sf_internal_predicateOutput = sobrevelocidad_carro; *)
                                    IF sobrevelocidad_carro THEN 
                                        (* Transition: '<S3>:42' *)
                                        is_Trolley_Emgy := c_TO_CODESYS_IN_NO_ACTIVE_C;
                                        temporalCounter_i1(timerAction := 1, maxTime := 0);
                                        is_Trolley_Emgy := c_TO_CODESYS_IN_Overspeed_D;
                                    ELSE 
                                        (* '<S3>:126:1' sf_internal_predicateOutput = after(10, sec); *)
                                        temporalCounter_i2(timerAction := 2, maxTime := 10000);
                                        IF temporalCounter_i2.done THEN 
                                            (* Transition: '<S3>:126' *)
                                            is_Trolley_Emgy := TO_CODESYS_IN_Solved;
                                            (* Entry 'Solved': '<S3>:47' *)
                                            (* '<S3>:47:3' trolley_emgy = false; *)
                                            trolley_emgy := FALSE;
                                            (* '<S3>:47:4' trolley_solved = true; *)
                                            trolley_solved := TRUE;
                                        END_IF;
                                    END_IF;
                                END_IF;
                            END_IF;
                        TO_CODESYS_IN_Overspeed: 
                            (* During 'Overspeed': '<S3>:39' *)
                            (* '<S3>:48:1' sf_internal_predicateOutput = abs(theta_l*180/pi) <= 1; *)
                            IF ABS((w_l_sensor * 180.0) / 3.1415926535897931) <= 1.0 THEN 
                                (* Transition: '<S3>:48' *)
                                (* Exit Internal 'Overspeed': '<S3>:39' *)
                                is_Overspeed := c_TO_CODESYS_IN_NO_ACTIVE_C;
                                is_Trolley_Emgy := TO_CODESYS_IN_Solved;
                                (* Entry 'Solved': '<S3>:47' *)
                                (* '<S3>:47:3' trolley_emgy = false; *)
                                trolley_emgy := FALSE;
                                (* '<S3>:47:4' trolley_solved = true; *)
                                trolley_solved := TRUE;
                            ELSE 
                                CASE is_Overspeed OF
                                    TO_CODESYS_IN_Init: 
                                        (* During 'Init': '<S3>:43' *)
                                        (* '<S3>:46:1' sf_internal_predicateOutput = after(3000, msec); *)
                                        temporalCounter_i1(timerAction := 2, maxTime := 3000);
                                        IF temporalCounter_i1.done THEN 
                                            (* Transition: '<S3>:46' *)
                                            is_Overspeed := TO_CODESYS_IN_Sway_Control;
                                            (* Entry 'Sway_Control': '<S3>:45' *)
                                            (* '<S3>:45:3' BRK_t = true; *)
                                            BRK_t := TRUE;
                                            (* '<S3>:45:4' sway_ctr_enable = true; *)
                                            sway_ctr_enable := TRUE;
                                        END_IF;
                                END_CASE;
                            END_IF;
                        c_TO_CODESYS_IN_Overspeed_D: 
                            (* During 'Overspeed_Delay': '<S3>:107' *)
                            (* '<S3>:108:1' sf_internal_predicateOutput = after(3000, msec); *)
                            temporalCounter_i1(timerAction := 2, maxTime := 3000);
                            IF temporalCounter_i1.done THEN 
                                (* Transition: '<S3>:108' *)
                                is_Trolley_Emgy := TO_CODESYS_IN_Overspeed;
                                (* Entry 'Overspeed': '<S3>:39' *)
                                (* '<S3>:39:3' sway_ctr_enable = false; *)
                                sway_ctr_enable := FALSE;
                                (* Entry Internal 'Overspeed': '<S3>:39' *)
                                (* Transition: '<S3>:44' *)
                                temporalCounter_i1(timerAction := 1, maxTime := 0);
                                is_Overspeed := TO_CODESYS_IN_Init;
                            END_IF;
                    END_CASE;
                END_IF;
            ELSE
                (* During 'Waiting_Global_Emgy_Ack': '<S3>:87' *)
                (* '<S3>:91:1' sf_internal_predicateOutput = cmd_global_emgy_ack; *)
                IF JS_emgy_ack_cmd THEN 
                    (* Transition: '<S3>:91' *)
                    (* '<S3>:91:1' emgy=false; *)
                    is_Emergencies := TO_CODESYS_IN_Stand_By;
                    (* Entry 'Stand_By': '<S3>:27' *)
                    (* '<S3>:27:3' hoist_solved = false; *)
                    hoist_solved := FALSE;
                    (* '<S3>:27:4' trolley_solved = false; *)
                    trolley_solved := FALSE;
                    (* '<S3>:27:5' emgy = false; *)
                    emgy := FALSE;
                END_IF;
        END_CASE;
        (* During 'Watchdog': '<S3>:12' *)
        CASE is_Watchdog OF
            c_TO_CODESYS_IN_Increase_co: 
                (* During 'Increase_counter': '<S3>:15' *)
                (* Transition: '<S3>:16' *)
                is_Watchdog := c_TO_CODESYS_IN_NO_ACTIVE_C;
                temporalCounter_i4(timerAction := 1, maxTime := 0);
                is_Watchdog := TO_CODESYS_IN_Init_et;
            TO_CODESYS_IN_Init_et: 
                (* During 'Init': '<S3>:13' *)
                (* '<S3>:19:1' sf_internal_predicateOutput = heartbeat_prev ~= heartbeat; *)
                IF heartbeat_prev <> heartbeat THEN 
                    (* Transition: '<S3>:19' *)
                    is_Watchdog := TO_CODESYS_IN_Reset_Counter;
                    (* Entry 'Reset_Counter': '<S3>:18' *)
                    (* '<S3>:18:3' counter = 0; *)
                    b_counter := 0;
                    (* '<S3>:18:4' heartbeat_prev = heartbeat; *)
                    heartbeat_prev := heartbeat;
                ELSE 
                    (* '<S3>:22:1' sf_internal_predicateOutput = counter >= 5; *)
                    IF b_counter >= 5 THEN 
                        (* Transition: '<S3>:22' *)
                        is_Watchdog := TO_CODESYS_IN_Watchdog_Emgy;
                        (* Entry 'Watchdog_Emgy': '<S3>:21' *)
                        (* '<S3>:21:3' watchdog_fail = true; *)
                        watchdog_fail := TRUE;
                    ELSE 
                        (* '<S3>:17:1' sf_internal_predicateOutput = after(200, msec); *)
                        temporalCounter_i4(timerAction := 2, maxTime := 200);
                        IF temporalCounter_i4.done THEN 
                            (* Transition: '<S3>:17' *)
                            is_Watchdog := c_TO_CODESYS_IN_Increase_co;
                            (* Entry 'Increase_counter': '<S3>:15' *)
                            (* '<S3>:15:3' counter = counter + 1; *)
                            i := SINT_TO_DINT(b_counter) + 1;
                            IF (SINT_TO_DINT(b_counter) + 1) > 127 THEN 
                                i := 127;
                            END_IF;
                            b_counter := DINT_TO_SINT(i);
                        END_IF;
                    END_IF;
                END_IF;
            TO_CODESYS_IN_Reset_Counter: 
                (* During 'Reset_Counter': '<S3>:18' *)
                (* Transition: '<S3>:20' *)
                is_Watchdog := c_TO_CODESYS_IN_NO_ACTIVE_C;
                temporalCounter_i4(timerAction := 1, maxTime := 0);
                is_Watchdog := TO_CODESYS_IN_Init_et;
        END_CASE;
        (* Update for UnitDelay: '<S1>/Unit Delay16' *)
        UnitDelay16_DSTATE := emgy;
        (* End of Outputs for SubSystem: '<Root>/TO_CODESYS' *)
END_CASE;
END_FUNCTION_BLOCK
FUNCTION maximum: LREAL
VAR_INPUT
    x: ARRAY [0..9000] OF LREAL;
END_VAR
VAR_TEMP
    k: DINT;
    x_0: LREAL;
END_VAR
maximum := x[0];
FOR k := 0 TO 8999 DO 
    x_0 := x[k + 1];
    IF maximum < x_0 THEN 
        maximum := x_0;
    END_IF;
END_FOR;
END_FUNCTION
FUNCTION maximum_d: LREAL
VAR_INPUT
    x: ARRAY [0..1] OF LREAL;
END_VAR
IF x[0] < x[1] THEN 
    maximum_d := x[1];
ELSE 
    maximum_d := x[0];
END_IF;
END_FUNCTION
FUNCTION minimum: LREAL
VAR_INPUT
    x: ARRAY [0..1] OF LREAL;
END_VAR
IF x[0] > x[1] THEN 
    minimum := x[1];
ELSE 
    minimum := x[0];
END_IF;
END_FUNCTION
FUNCTION rt_floord: LREAL
VAR_INPUT
    u: LREAL;
END_VAR
rt_floord := DINT_TO_LREAL(TRUNC(u));
IF u = rt_floord THEN 
    rt_floord := u;
ELSIF u < 0.0 THEN 
    rt_floord := rt_floord - 1.0;
END_IF;
END_FUNCTION
FUNCTION rt_ceild: LREAL
VAR_INPUT
    u: LREAL;
END_VAR
rt_ceild := DINT_TO_LREAL(TRUNC(u));
IF u = rt_ceild THEN 
    rt_ceild := u;
ELSIF u >= 0.0 THEN 
    rt_ceild := rt_ceild + 1.0;
END_IF;
END_FUNCTION
FUNCTION_BLOCK PLC_CODER_TIMER
VAR_INPUT
    timerAction: INT;
    maxTime: DINT;
END_VAR
VAR_OUTPUT
    done: BOOL;
END_VAR
VAR
    plcTimer: TON;
    plcTimerExpired: BOOL;
END_VAR
CASE timerAction OF
    1:
        (* RESET *)
        plcTimer(IN:=FALSE, PT:=T#0ms);
        plcTimerExpired := FALSE;
        done := FALSE;
    2:
        (* AFTER *)
        IF (NOT(plcTimerExpired)) THEN
            plcTimer(IN:=TRUE, PT:=DINT_TO_TIME(maxTime));
        END_IF;
        plcTimerExpired := plcTimer.Q;
        done := plcTimerExpired;
    3:
        (* BEFORE *)
        IF (NOT(plcTimerExpired)) THEN
            plcTimer(IN:=TRUE, PT:=DINT_TO_TIME(maxTime));
        END_IF;
        plcTimerExpired := plcTimer.Q;
        done := NOT(plcTimerExpired);
END_CASE;
END_FUNCTION_BLOCK
VAR_GLOBAL CONSTANT
    TO_CODESYS_x_c0_left: LREAL := -35.0;
    TO_CODESYS_lidar_grid_size: LREAL := 9001.0;
    TO_CODESYS_y_h_min: LREAL := -20.0;
    TO_CODESYS_H_c: LREAL := 2.59;
    c_TO_CODESY_x_containers_le: LREAL := 1.5;
    c_TO_CODESYS_IN_NO_ACTIVE_C: USINT := 0;
    c_TO_CODESYS_IN_Heartbeat_H: USINT := 1;
    TO_CODESYS_IN_Heartbeat_Low: USINT := 2;
    TO_CODESYS_IN_BRK_t_Closed: USINT := 1;
    TO_CODESYS_IN_BRK_t_Opened: USINT := 2;
    TO_CODESYS_IN_BRK_h_Closed: USINT := 1;
    TO_CODESYS_IN_BRK_h_Opened: USINT := 2;
    TO_CODESYS_IN_Init: USINT := 1;
    TO_CODESYS_IN_TLK_Closed: USINT := 2;
    TO_CODESYS_IN_TLK_Opened: USINT := 3;
    c_TO_CODESYS_IN_Sway_Contro: USINT := 1;
    d_TO_CODESYS_IN_Sway_Contro: USINT := 2;
    TO_CODESYS_IN_FC_t_Min_High: USINT := 1;
    TO_CODESYS_IN_FC_t_Min_Low: USINT := 2;
    TO_CODESYS_IN_FC_t_Max_High: USINT := 1;
    TO_CODESYS_IN_FC_t_Max_Low: USINT := 2;
    TO_CODESYS_IN_FC_h_Min_High: USINT := 1;
    TO_CODESYS_IN_FC_h_Min_Low: USINT := 2;
    TO_CODESYS_IN_FC_h_Max_High: USINT := 1;
    TO_CODESYS_IN_FC_h_Max_Low: USINT := 2;
    TO_CODESYS_IN_Automatic: USINT := 1;
    TO_CODESYS_IN_Manual: USINT := 2;
    c_TO_CODESYS_IN_Line_Scan_M: USINT := 1;
    c_TO_CODESYS_IN_Line_Scan_R: USINT := 2;
    d_TO_CODESYS_IN_Line_Scan_R: USINT := 3;
    c_TO_COD_IN_Pickup_And_Plac: USINT := 4;
    c_TO_CODESYS_IN_Scenario_Se: USINT := 5;
    c_TO_CODES_IN_Scenario_Sele: USINT := 2;
    c_TO_CO_IN_Ship_Palcement_D: USINT := 3;
    c_TO_CODES_IN_Ship_Pickup_D: USINT := 4;
    c_TO_CODESY_IN_Ship_Pickup_: USINT := 5;
    c_TO_CODESYS_IN_Ship_Pickup: USINT := 6;
    d_TO_CODESYS_IN_Ship_Pickup: USINT := 7;
    c_TO_COD_IN_Ship_Placement_: USINT := 8;
    c_TO_CODES_IN_Ship_Placemen: USINT := 9;
    c_TO_CODE_IN_Ship_Placement: USINT := 10;
    c_TO_CODE_IN_Truck_Pickup_D: USINT := 11;
    c_TO_CODES_IN_Truck_Pickup_: USINT := 12;
    c_TO_CODESYS_IN_Truck_Picku: USINT := 13;
    c_TO_CODESY_IN_Truck_Pickup: USINT := 14;
    c_TO_C_IN_Truck_Placement_D: USINT := 15;
    c_TO_CO_IN_Truck_Placement_: USINT := 16;
    c_TO_CODE_IN_Truck_Placemen: USINT := 17;
    c_TO_COD_IN_Truck_Placement: USINT := 18;
    c_TO_CODESYS_IN_Trolley_Mov: USINT := 1;
    c_TO_CODESYS_IN_Trolley_Sto: USINT := 2;
    c_TOZZIN_Trolley_Stopped_Co: USINT := 3;
    TO_CODESYS_IN_Hoist_Moving: USINT := 1;
    TO_CODESYS_IN_Hoist_Stopped: USINT := 2;
    TO_CODESYS_l_h_safety_min: LREAL := 7.5;
    TO_CODESYS_x_t_safety_max: LREAL := 47.5;
    TO_CODESYS_l_h_safety_max: LREAL := 62.5;
    TO_CODESYS_x_t_safety_min: LREAL := -27.5;
    TO_CODESYS_IN_Global_Emgy: USINT := 1;
    TO_CODESYS_IN_Hoist_Emgy: USINT := 2;
    TO_CODESYS_IN_Stand_By: USINT := 3;
    TO_CODESYS_IN_Trolley_Emgy: USINT := 4;
    c_TO_C_IN_Waiting_Global_Em: USINT := 5;
    c_TO_CODESYS_IN_Emgy_Switch: USINT := 1;
    d_TO_CODESYS_IN_Emgy_Switch: USINT := 2;
    TO_CODESYS_IN_Init_e: USINT := 3;
    TO_CODESYS_IN_Overspeed: USINT := 4;
    c_TO_CODESYS_IN_Overspeed_D: USINT := 5;
    TO_CODESYS_IN_Solved: USINT := 6;
    TO_CODESYS_IN_Sway_Control: USINT := 2;
    c_TO_CODESYS_IN_Increase_co: USINT := 1;
    TO_CODESYS_IN_Init_et: USINT := 2;
    TO_CODESYS_IN_Reset_Counter: USINT := 3;
    TO_CODESYS_IN_Watchdog_Emgy: USINT := 4;
    SS_INITIALIZE: SINT := 0;
    SS_STEP: SINT := 1;
END_VAR

module PresenceDetection(
  input wire clk,
  input wire presence,
  output reg away
);
  always @(posedge clk) begin
    away <= presence ? 1'b1 : 1'b0;
  end
endmodule

module TemperatureMonitoring(
  input wire clk,
  input wire [5:0] temperature,
  output reg [5:0] temperatureData
);
  always @(posedge clk) begin
    temperatureData <= temperature;
  end
endmodule

module LightingControl(
  input wire clk,
  input wire [2:0] luminosity,
  input wire away,
  input wire manualSwitch,
  output reg [5:0] lightState
);
  always @(posedge clk) begin
    if (away)
      lightState <= 6'b000000;
    else if (manualSwitch)
      lightState <= 6'b111111;
    else if (luminosity > 3'b010)
      lightState <= 6'b111111;
    else
      lightState <= 6'b000000;
  end
endmodule

module HomeSecurity(
  input wire clk,
  input wire [4:0] motionSensors,
  input wire [3:0] pin,
  output reg [1:0] mode
);
  reg alarm;
  
  always @(posedge clk) begin
    if (mode == 2'b00 && motionSensors != 5'b00000) begin
      alarm <= 1'b1;
      mode <= 2'b01;
    end else if (mode == 2'b01 && pin == 4'b0000) begin
      alarm <= 1'b0;
      mode <= 2'b10;
    end else if (mode == 2'b10 && pin != 4'b0000) begin
      mode <= 2'b00;
    end
  end
endmodule

module StabilizerControl(
  input wire clk,
  input wire [7:0] voltage,
  output reg relay
);
  always @(posedge clk) begin
    relay <= (voltage < 8'b11011100 || voltage > 8'b11100110) ? 1'b1 : 1'b0;
  end
endmodule

module HomeAutomationSystem(
  input wire clk,
  input wire presence,
  input wire [5:0] temperature,
  input wire [2:0] luminosity,
  input wire [4:0] motionSensors,
  input wire [3:0] pin,
  input wire [7:0] voltage,
  input wire manualSwitch,
  output reg away,
  output reg [5:0] temperatureData,
  output reg [5:0] lightState,
  output reg [1:0] mode,
  output reg relay
);
  PresenceDetection presenceDetection(
    .clk(clk),
    .presence(presence),
    .away(away)
  );
  
  TemperatureMonitoring temperatureMonitoring(
    .clk(clk),
    .temperature(temperature),
    .temperatureData(temperatureData)
  );
  
  LightingControl lightingControl(
    .clk(clk),
    .luminosity(luminosity),
    .away(away),
    .manualSwitch(manualSwitch),
    .lightState(lightState)
  );
  
  HomeSecurity homeSecurity(
    .clk(clk),
    .motionSensors(motionSensors),
    .pin(pin),
    .mode(mode)
  );
  
  StabilizerControl stabilizerControl(
    .clk(clk),
    .voltage(voltage),
    .relay(relay)
  );
endmodule

// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RayFX"
{
	Properties
	{
		_BodyScaler("BodyScaler", Float) = 0
		_WingScaler("WingScaler", Float) = 1
		_BodyTimeScaler("BodyTimeScaler", Float) = 0
		_PositionalTimeScaler("PositionalTimeScaler", Float) = 0
		_WingTimeScaler("WingTimeScaler", Float) = 1
		_BodyPower("BodyPower", Float) = 0
		_WingPower("WingPower", Float) = 0.5
		_BodyPositoinalAmplitudeScalar("Body Positoinal Amplitude Scalar", Float) = 0
		_WingPositoinalAmplitudeScalar("Wing Positoinal Amplitude Scalar", Float) = 0
		_MainTex("MainTex", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _BodyScaler;
		uniform float _BodyTimeScaler;
		uniform float _BodyPower;
		uniform float _BodyPositoinalAmplitudeScalar;
		uniform float _WingScaler;
		uniform float _WingTimeScaler;
		uniform float _WingPower;
		uniform float _WingPositoinalAmplitudeScalar;
		uniform float _PositionalTimeScaler;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float mulTime35 = _Time.y * -1.0;
			float4 appendResult15 = (float4(0.0 , ( ( _BodyScaler * sin( ( ( _BodyTimeScaler * _Time.y ) + ( ase_vertex3Pos.z * _BodyPower ) ) ) * ( ase_vertex3Pos.z * _BodyPositoinalAmplitudeScalar ) * v.color.g ) + ( _WingScaler * sin( ( ( _WingTimeScaler * mulTime35 * sign( ase_vertex3Pos.x ) ) + ( ase_vertex3Pos.x * _WingPower ) ) ) * ( ase_vertex3Pos.x * _WingPositoinalAmplitudeScalar ) * v.color.r ) + ( sin( ( _PositionalTimeScaler * _Time.y ) ) * 0.1 ) ) , 0.0 , 0.0));
			v.vertex.xyz += appendResult15.xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 color55 = IsGammaSpace() ? float4(0.6226415,0.6226415,0.6226415,0) : float4(0.3456162,0.3456162,0.3456162,0);
			o.Albedo = ( tex2D( _MainTex, uv_MainTex ) * color55 ).rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16301
215.2;163.2;1534;800;1572.407;-468.2941;1.387959;True;True
Node;AmplifyShaderEditor.CommentaryNode;29;-1969.193,1099.704;Float;False;922.8853;762;Adding the scaled and offset time value to the vertex's y position;5;40;39;31;30;53;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;31;-1982.629,1512.725;Float;False;498;326;Scales Vertex Z Position;3;50;49;48;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;22;-1957.003,-14.84087;Float;False;922.8853;762;Adding the scaled and offset time value to the vertex's y position;4;13;5;20;21;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;30;-1825.193,1149.704;Float;False;394;324;Scales and Offsets Time Input;3;38;36;35;;1,1,1,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;48;-1984.095,1558.999;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;20;-1907.003,395.1588;Float;False;498;326;Scales Vertex Z Position;3;17;19;16;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;21;-1813.003,35.159;Float;False;394;324;Scales and Offsets Time Input;3;9;8;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-1933.43,1716.676;Float;False;Property;_WingPower;WingPower;6;0;Create;True;0;0;False;0;0.5;0.6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-1878.175,599.0636;Float;False;Property;_BodyPower;BodyPower;5;0;Create;True;0;0;False;0;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SignOpNode;53;-1725.121,1428.435;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;16;-1816.336,444.4541;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;8;-1763.118,91.68213;Float;False;Property;_BodyTimeScaler;BodyTimeScaler;2;0;Create;True;0;0;False;0;0;1.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;35;-1777.308,1299.227;Float;False;1;0;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-1775.308,1206.227;Float;False;Property;_WingTimeScaler;WingTimeScaler;4;0;Create;True;0;0;False;0;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;2;-1765.118,184.6821;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;32;-1589.139,1882.234;Float;False;543.639;249.309;Uses distance from origin as scalar multiplier of amplitude;2;47;46;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;28;-1576.949,767.6889;Float;False;543.639;249.309;Uses distance from origin as scalar multiplier of amplitude;2;27;26;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1603.135,489.9545;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-436.7162,792.1139;Float;False;Property;_PositionalTimeScaler;PositionalTimeScaler;3;0;Create;True;0;0;False;0;0;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-1580.735,1264.145;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1579.118,161.6822;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;60;-418.3161,882.514;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;50;-1671.736,1608.33;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;-230.3162,841.9141;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;33;-1016.708,1102.427;Float;False;553.9999;353;Scaling and offsetting sin ouput;2;43;41;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;24;-1004.519,-12.11767;Float;False;553.9999;353;Scaling and offsetting sin ouput;2;3;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1526.949,901.9988;Float;False;Property;_BodyPositoinalAmplitudeScalar;Body Positoinal Amplitude Scalar;7;0;Create;True;0;0;False;0;0;4.7;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;-1386.149,1235.468;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-1324.118,158.6821;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-1539.139,2016.544;Float;False;Property;_WingPositoinalAmplitudeScalar;Wing Positoinal Amplitude Scalar;8;0;Create;True;0;0;False;0;0;-0.25;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-954.5193,37.88221;Float;False;Property;_BodyScaler;BodyScaler;0;0;Create;True;0;0;False;0;0;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;40;-1188.307,1273.227;Float;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;64;-84.55862,852.665;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;5;-1176.118,158.6821;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.VertexColorNode;58;-1050.106,581.6504;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-1214.499,1932.234;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;41;-966.7086,1152.427;Float;False;Property;_WingScaler;WingScaler;1;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1202.31,817.689;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-110.1295,949.2046;Float;False;Constant;_PositionalPower;PositionalPower;10;0;Create;True;0;0;False;0;0.1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;70.57053,885.5041;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-784.5193,41.88221;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-796.7086,1156.427;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;25;-159.6015,426.2829;Float;False;217;229;Applying result to x axis;1;15;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-367.7432,639.3652;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;56;-310.3509,-313.6768;Float;True;Property;_MainTex;MainTex;9;0;Create;True;0;0;False;0;None;bea7fa376f932ba419f3d1fc95bd1a2b;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;55;-274.7573,-98.61688;Float;False;Constant;_Tint;Tint;8;0;Create;True;0;0;False;0;0.6226415,0.6226415,0.6226415,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;15;-109.6012,476.2828;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;57;28.96785,-98.82408;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;583.3579,18.73574;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;RayFX;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;53;0;48;1
WireConnection;17;0;16;3
WireConnection;17;1;19;0
WireConnection;38;0;36;0
WireConnection;38;1;35;0
WireConnection;38;2;53;0
WireConnection;9;0;8;0
WireConnection;9;1;2;0
WireConnection;50;0;48;1
WireConnection;50;1;49;0
WireConnection;62;0;61;0
WireConnection;62;1;60;0
WireConnection;39;0;38;0
WireConnection;39;1;50;0
WireConnection;13;0;9;0
WireConnection;13;1;17;0
WireConnection;40;0;39;0
WireConnection;64;0;62;0
WireConnection;5;0;13;0
WireConnection;47;0;48;1
WireConnection;47;1;46;0
WireConnection;26;0;16;3
WireConnection;26;1;27;0
WireConnection;65;0;64;0
WireConnection;65;1;66;0
WireConnection;4;0;3;0
WireConnection;4;1;5;0
WireConnection;4;2;26;0
WireConnection;4;3;58;2
WireConnection;43;0;41;0
WireConnection;43;1;40;0
WireConnection;43;2;47;0
WireConnection;43;3;58;1
WireConnection;51;0;4;0
WireConnection;51;1;43;0
WireConnection;51;2;65;0
WireConnection;15;1;51;0
WireConnection;57;0;56;0
WireConnection;57;1;55;0
WireConnection;0;0;57;0
WireConnection;0;11;15;0
ASEEND*/
//CHKSM=45E37A8472F2ADC64F42E2F82490A880EA0B20C5
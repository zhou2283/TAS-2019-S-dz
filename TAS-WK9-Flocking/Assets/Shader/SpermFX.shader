// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SpermFX"
{
	Properties
	{
		_HAmplitude("HAmplitude", Float) = 0
		_VAmplitude("VAmplitude", Float) = 0
		_TimeOffset("Time Offset", Float) = 0
		_Frequency("Frequency", Float) = 0
		_HAmplitudeOffset("HAmplitude Offset", Float) = 0
		_VAmplitudeOffset("VAmplitude Offset", Float) = 0
		_PositionalOffsetScalar("Positional Offset Scalar", Float) = 0
		_PositoinalAmplitudeScalar("Positoinal Amplitude Scalar", Float) = 0
		_HTwist("HTwist", Float) = 0
		_VTwist("VTwist", Float) = 0
		_RimColor("RimColor", Color) = (1,1,1,0)
		_BaseColor("BaseColor", Color) = (0.754717,0.7084341,0.6657174,0)
		_Scale("Scale", Float) = 1
		_Power("Power", Float) = 2
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float3 worldPos;
			float3 worldNormal;
		};

		uniform float _HTwist;
		uniform float _HAmplitude;
		uniform float _Frequency;
		uniform float _TimeOffset;
		uniform float _PositionalOffsetScalar;
		uniform float _PositoinalAmplitudeScalar;
		uniform float _HAmplitudeOffset;
		uniform float _VTwist;
		uniform float _VAmplitude;
		uniform float _VAmplitudeOffset;
		uniform float4 _RimColor;
		uniform float _Scale;
		uniform float _Power;
		uniform float4 _BaseColor;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float temp_output_35_0 = ( ase_vertex3Pos.z * ase_vertex3Pos.z );
			float temp_output_5_0 = sin( ( ( _Frequency * _Time.y ) + _TimeOffset + ( ase_vertex3Pos.z * _PositionalOffsetScalar ) ) );
			float temp_output_26_0 = ( ase_vertex3Pos.z * _PositoinalAmplitudeScalar );
			float4 appendResult15 = (float4(( ( temp_output_35_0 * _HTwist ) + ( ( _HAmplitude * temp_output_5_0 * temp_output_26_0 ) + _HAmplitudeOffset ) ) , ( ( temp_output_35_0 * _VTwist ) + ( ( _VAmplitude * temp_output_5_0 * temp_output_26_0 ) + _VAmplitudeOffset ) ) , 0.0 , 0.0));
			v.vertex.xyz += appendResult15.xyz;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float3 ase_worldNormal = i.worldNormal;
			float fresnelNdotV44 = dot( ase_worldNormal, ase_worldViewDir );
			float fresnelNode44 = ( 0.0 + _Scale * pow( 1.0 - fresnelNdotV44, _Power ) );
			o.Emission = saturate( ( ( _RimColor * fresnelNode44 ) + _BaseColor ) ).rgb;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float3 worldPos : TEXCOORD1;
				float3 worldNormal : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.worldNormal = worldNormal;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = IN.worldNormal;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
6.4;6.4;1523;789;752.953;463.7221;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;22;-2198.987,278.6115;Float;False;922.8853;762;Adding the scaled and offset time value to the vertex's y position;4;13;5;20;21;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;21;-2054.987,328.6113;Float;False;394;324;Scales and Offsets Time Input;4;6;9;8;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;20;-2148.987,688.6115;Float;False;498;326;Scales Vertex Y Position;3;17;19;16;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-2005.102,385.1345;Float;False;Property;_Frequency;Frequency;3;0;Create;True;0;0;False;0;0;13.33;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;2;-2007.102,478.1346;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;16;-2058.32,737.9067;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;-2120.158,892.5162;Float;False;Property;_PositionalOffsetScalar;Positional Offset Scalar;6;0;Create;True;0;0;False;0;0;9.67;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1821.102,455.1346;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1845.102,557.1348;Float;False;Property;_TimeOffset;Time Offset;2;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1845.119,783.4071;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;28;-1818.933,1061.141;Float;False;543.639;249.309;Uses distance from origin as scalar multiplier of amplitude;2;27;26;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;36;-1108.222,703.4078;Float;False;553.9999;353;Scaling and offsetting sin ouput;4;40;39;38;37;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;24;-1331.6,261.3117;Float;False;553.9999;353;Scaling and offsetting sin ouput;4;3;4;10;7;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;13;-1566.102,452.1345;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1768.933,1195.45;Float;False;Property;_PositoinalAmplitudeScalar;Positoinal Amplitude Scalar;7;0;Create;True;0;0;False;0;0;-1.93;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1444.294,1111.141;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;29;-994.5405,-175.9466;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;5;-1418.102,452.1345;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;38;-1080.623,750.2076;Float;False;Property;_VAmplitude;VAmplitude;1;0;Create;True;0;0;False;0;0;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-1304,308.1115;Float;False;Property;_HAmplitude;HAmplitude;0;0;Create;True;0;0;False;0;0;0.02;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-718.9525,-228.2221;Float;False;Property;_Scale;Scale;12;0;Create;True;0;0;False;0;1;5.67;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-707.9525,-142.2221;Float;False;Property;_Power;Power;13;0;Create;True;0;0;False;0;2;2.42;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FresnelNode;44;-519.301,-215.7522;Float;True;Standard;WorldNormal;ViewDir;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1.65;False;3;FLOAT;3.94;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;43;-536.6479,-388.4174;Float;False;Property;_RimColor;RimColor;10;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;33;-837.1469,94.48548;Float;False;Property;_VTwist;VTwist;9;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-875.1404,13.22189;Float;False;Property;_HTwist;HTwist;8;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;-820.7628,-44.90092;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-1045.422,970.2077;Float;False;Property;_VAmplitudeOffset;VAmplitude Offset;5;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-1111.6,315.3115;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-888.2227,757.4076;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-1268.799,528.1114;Float;False;Property;_HAmplitudeOffset;HAmplitude Offset;4;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;37;-708.2222,757.4076;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;-671.4529,63.8797;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-659.8441,-18.43923;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;7;-931.5994,315.3115;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-201.3691,-216.983;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;42;-361.6479,-26.91742;Float;False;Property;_BaseColor;BaseColor;11;0;Create;True;0;0;False;0;0.754717,0.7084341,0.6657174,0;0.3679245,0.3254049,0.2828853,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-336.4156,652.0913;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;32;-381.7656,295.5732;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;25;-300.4957,228.0251;Float;False;217;229;Applying result to x axis;1;15;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-88.36914,-136.983;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;15;-206.17,294.9109;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SaturateNode;49;89.047,-137.7221;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;163,0;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;SpermFX;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;9;0;8;0
WireConnection;9;1;2;0
WireConnection;17;0;16;3
WireConnection;17;1;19;0
WireConnection;13;0;9;0
WireConnection;13;1;6;0
WireConnection;13;2;17;0
WireConnection;26;0;16;3
WireConnection;26;1;27;0
WireConnection;5;0;13;0
WireConnection;44;2;47;0
WireConnection;44;3;48;0
WireConnection;35;0;29;3
WireConnection;35;1;29;3
WireConnection;4;0;3;0
WireConnection;4;1;5;0
WireConnection;4;2;26;0
WireConnection;40;0;38;0
WireConnection;40;1;5;0
WireConnection;40;2;26;0
WireConnection;37;0;40;0
WireConnection;37;1;39;0
WireConnection;34;0;35;0
WireConnection;34;1;33;0
WireConnection;31;0;35;0
WireConnection;31;1;30;0
WireConnection;7;0;4;0
WireConnection;7;1;10;0
WireConnection;45;0;43;0
WireConnection;45;1;44;0
WireConnection;41;0;34;0
WireConnection;41;1;37;0
WireConnection;32;0;31;0
WireConnection;32;1;7;0
WireConnection;46;0;45;0
WireConnection;46;1;42;0
WireConnection;15;0;32;0
WireConnection;15;1;41;0
WireConnection;49;0;46;0
WireConnection;0;2;49;0
WireConnection;0;11;15;0
ASEEND*/
//CHKSM=C0AA1FBD3CEFD30090C7021E2D650201C2D3B446
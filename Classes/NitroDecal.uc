class NitroDecal extends ProjectedDecal;

#exec OBJ LOAD FILE=HTec_A.ukx

simulated function BeginPlay()
{
    if ( !Level.bDropDetail && FRand() < 0.4 )
        ProjTexture = texture'HTec_A.Nitro.NitroSplat';
    Super.BeginPlay();
}

defaultproperties
{
     bClipStaticMesh=True
     CullDistance=7000.000000
     LifeSpan=5.000000
     DrawScale=0.500000
}

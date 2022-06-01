--FFNF(아이리스 리브레) 에밀 베르탱
local m=81210040
local cm=_G["c"..m]
function cm.initial_effect(c)

	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2,cm.mat1)
	
	--ritual
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,81210041)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end
--material
function cm.mfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_PENDULUM)
end
function cm.mat1(g,lc)
	return g:IsExists(cm.mfilter,1,nil)
end

--ritual
function cm.spfil0(c,e,tp,mg)
	if not c:IsSetCard(0xcb9) or bit.band(c:GetType(),0x81)~=0x81 then
		return false
	end
	local m=mg:Clone()
	m:RemoveCard(c)
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,c:GetLevel(),"Greater")
	local res=m:CheckSubGroup(cm.mfil0,1,c:GetLevel(),e,tp,c)
	aux.GCheckAdditional=nil
	return res
end
function cm.mfil0(sg,e,tp,rc)
	Duel.SetSelectedCard(sg)
	return sg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
	and 
		( (rc:IsLocation(0x40) and rc:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,sg,rc)>0) 
	or
		(not rc:IsLocation(0x40) and Duel.GetMZoneCount(tp,sg)>0) )
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingMatchingCard(cm.spfil0,tp,0x02+0x40,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x02+0x40)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,cm.spfil0,tp,0x02+0x40,0,1,1,nil,e,tp,mg)
	local tc=tg:GetFirst()
	if tc then
		mg:RemoveCard(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,cm.mfil0,false,1,tc:GetLevel(),e,tp,tc)
		aux.GCheckAdditional=nil
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

--extra summon
function cm.tg2(e,c)
	return c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_MACHINE)
end

--서치
function cm.tfil0(c)
	return c:IsAbleToHand() and c:IsType(TYPE_PENDULUM) and ( c:IsSetCard(0xcb9) or c:IsSetCard(0xcba) )
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(tp)
	end
	if chk==0 then
		return Duel.IsExistingTarget(aux.TRUE,tp,0x0c,0,1,c)
		and Duel.IsExistingMatchingCard(cm.tfil0,tp,0x01,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0x0c,0,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x01)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(cm.tfil0,tp,0x01,0,nil)
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end

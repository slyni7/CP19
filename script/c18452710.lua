--»Ç¾é°Ô ½×ÀÌ´Â ÀÌ °¨Á¤À»(³×ÇÁµð¼À¹ö¡¡ Ç»Àü)
function c18452710.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetTarget(c18452710.tar1)
	e1:SetOperation(c18452710.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetCountLimit(1)
	e2:SetTarget(c18452710.tar2)
	e2:SetOperation(c18452710.op2)
	c:RegisterEffect(e2)
end
function c18452710.tfil11(c,e,tp,tc)
	local ft=0
	if not tc:IsLocation(LOCATION_SZONE) then
		ft=ft+1
	end
	return c:IsSetCard(0x2cf) and c:IsType(TYPE_SPELL) and c:IsSSetable() and (not c:IsCode(18452710))
		and (Duel.GetLocationCount(tp,LOCATION_SZONE)>ft or c:IsType(TYPE_FIELD))
		and Duel.IsExistingMatchingCard(c18452710.tfil12,tp,LOCATION_EXTRA,0,1,nil,e,tp,Group.FromCards(c,tc))
end
function c18452710.tfil12(c,e,tp,m)
	return c.december_fmaterial and c:IsType(TYPE_FUSION) and c:IsSetCard(0x2cf)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,tp)
end
function c18452710.tar1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(c18452710.tfil11,tp,LOCATION_DECK,0,1,nil,e,tp,c)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c18452710.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c18452710.tfil11,tp,LOCATION_DECK,0,1,1,nil,e,tp,c)
	local tc=g:GetFirst()
	if not tc then
		return
	end
	Duel.SSet(tp,tc)
	local mg=Group.FromCards(c,tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c18452710.tfil12,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	local sc=sg:GetFirst()
	if sc then
		local mat=Duel.SelectFusionMaterial(tp,sc,mg,nil,tp)
		sc:SetMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
		Duel.Equip(tp,c,sc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetLabelObject(sc)
		e1:SetValue(c18452710.oval11)
		c:RegisterEffect(e1)
	end
end
function c18452710.oval11(e,c)
	return e:GetLabelObject()==c
end
function c18452710.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if chk==0 then
		local g=Group.FromCards(c,ec)
		return Duel.IsExistingMatchingCard(c18452710.tfil12,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c18452710.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local ec=c:GetEquipTarget()
	local mg=Group.FromCards(c,ec)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c18452710.tfil12,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	local sc=sg:GetFirst()
	if sc then
		local mat=Duel.SelectFusionMaterial(tp,sc,mg,nil,tp)
		sc:SetMaterial(mat)
		Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
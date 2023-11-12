--빙결정령사 아우스
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"F","H")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTR(POS_FACEUP,1)
	e1:SetCondition(s.con1)
	e1:SetTarget(s.tar1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCL(id)
	WriteEff(e2,2,"TO")
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_BE_MATERIAL)
	WriteEff(e3,3,"N")
	c:RegisterEffect(e3)
end
function s.nfil1(c,tp)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsFaceup() and Duel.GetMZoneCount(1-tp,c)>0
end
function s.con1(e,c)
	if c==nil then
		return true
	end
	local tp=c:GetControler()
	return Duel.IEMCard(s.nfil1,tp,0,"M",1,nil,tp) and Duel.GetLocCount(tp,"S")>0
end
function s.tar1(e,tp,eg,ep,ev,re,r,rp,chk,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SMCard(tp,s.nfil1,tp,0,"M",0,1,nil,tp)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else
		return false
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	local tc=g:GetFirst()
	local og=tc:GetOverlayGroup()
	local tempc=Duel.GetFirstMatchingCard(nil,tp,0xf3,0xf3,nil)
	Duel.Overlay(tempc,og)
	Duel.MoveToField(tc,tp,tp,LSTN("S"),POS_FACEUP,true)
	Duel.Overlay(tc,og)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	tc:RegisterEffect(e1)
	local i=0
	while tc.eff_ct[tc][i] do
		local te=tc.eff_ct[tc][i]
		local trang=te:GetRange()
		if trang and trang&LSTN("M")~=0 then
			local e2=te:Clone()
			e2:SetRange(LSTN("S"))
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE)
			tc:RegisterEffect(e2)
		end
		i=i+1
	end
	g:DeleteGroup()
end
function s.tfil2(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and not c:IsCode(id)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IEMCard(s.tfil2,tp,"DE",0,1,nil) and Duel.GetLocCount(tp,"S")>0
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocCount(tp,"S")<1 then
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SMCard(tp,s.tfil2,tp,"DE",0,1,1,nil,tp)
	local tc=g:GetFirst()
	if not tc then
		return
	end
	Duel.MoveToField(tc,tp,tp,LSTN("S"),POS_FACEUP,true)
	if tc:IsType(TYPE_XYZ) and c:IsRelateToEffect(e) and Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,0)) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	tc:RegisterEffect(e1)
	local i=0
	while tc.eff_ct[tc][i] do
		local te=tc.eff_ct[tc][i]
		local trang=te:GetRange()
		if trang and trang&LSTN("M")~=0 then
			local e2=te:Clone()
			e2:SetRange(LSTN("S"))
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TEMP_REMOVE)
			tc:RegisterEffect(e2)
		end
		i=i+1
	end
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return rc:IsLink(2) and r&REASON_LINK~=0
end
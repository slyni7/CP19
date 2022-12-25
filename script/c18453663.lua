--엔젤 시무르그
local s,id=GetID()
function s.initial_effect(c)
	Xyz.AddProcedure(c,s.pfil1,7,2,s.pfil2,aux.Stringid(id,0))
	c:EnableReviveLimit()
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"STo")
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	WriteEff(e2,2,"NCTO")
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"S")
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetCondition(s.con3)
	e3:SetValue(s.val3)
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","M")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetCL(1)
	WriteEff(e4,4,"CTO")
	c:RegisterEffect(e4)
	local e5=MakeEff(c,"F","M")
	e5:SetCode(EFFECT_ANGEL_SIMORGH)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTR(1,0)
	c:RegisterEffect(e5)
end
function s.pfil1(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_WINGEDBEAST)
end
function s.pfil2(c,tp,xyzc)
	return c:IsFaceup() and c:IsSetCard(0x12d,xyzc,SUMMON_TYPE_XYZ,tp) and c:IsType(TYPE_XYZ,xyzc,SUMMON_TYPE_XYZ,tp)
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_XYZ)
end
function s.cfil2(c)
	return c:IsRace(RACE_WINGEDBEAST) and c:IsAbleToGraveAsCost()
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.cfil2,tp,LOCATION_DECK,0,nil)
	if chk==0 then
		return g:GetClassCount(Card.Attribute)>2
	end
	local tg=Group.CreateGroup()
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		g:Remove(Card.IsAttribute,nil,sg:GetFirst():GetAttribute())
		tg:Merge(sg)
	end
	Duel.SendtoGrave(tg,REASON_COST)
end
function s.tar2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFieldGroupCount(tp,0,LSTN("E"))>2
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GMGroup(Card.IsAbleToRemove,1-tp,"E",0,nil)
	if #g>2 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local sg=g:Select(1-tp,3,3,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function s.nfil3(c)
	return c:IsSetCard(0x12d) and c:IsMonster()
end
function s.con3(e)
	local c=e:GetHandler()
	return c:GetOverlayGroup():IsExists(s.nfil3,1,nil) and c:GetFlagEffect(id)==0
end
function s.val3(e,c)
	return c:GetOverlayGroup():FilterCount(s.nfil3,1,nil)
end
function s.cfil4(c)
	return c:IsMonster() and c:IsSetCard(0x12d)
end
function s.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.CheckReleaseGroup(tp,s.cfil4,1,nil) and c:GetAttackAnnouncedCount()<2
	end
	c:RegisterFlagEffect(id,RESET_PHASE+PHASE_END+RESET_EVENT+0x1ec0000,0,1)
	local sg=Duel.SelectReleaseGroup(tp,s.cfil4,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsOnField() and chkc:IsControler(1-tp)
	end
	if chk==0 then
		return Duel.IETarget(aux.TRUE,tp,0,"O",1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.STarget(tp,aux.TRUE,tp,0,"O",1,1,nil)
	Duel.SOI(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
